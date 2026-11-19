"""Data loading, cleaning and quality checks.

The original repository mixes three representations of the same data:

* ``Data/bd_definitiva.csv``: raw values with ``%``/``$`` strings;
* ``cred/data/bdd_int.csv``: an old, partially corrupted integer export;
* the ``country/30`` facts inside ``code.pl``: the actual model input.

This module treats ``code.pl`` as the canonical model data and the raw CSV as
the human-readable source.  It exposes both, plus an audit that flags the rows
where the integer export does not match the raw values.
"""

from __future__ import annotations

import math
import re
from dataclasses import dataclass
from pathlib import Path

import pandas as pd

from .model import FuzzyModel
from .variables import RAW_COLUMNS, VARIABLES

_ID_COLUMNS = ("country_id", "country")
_NUMERIC_CLEAN_RE = re.compile(r"[%$,\s]")


@dataclass(frozen=True)
class DatasetPaths:
    """Default locations of the project data files."""

    raw: Path = Path("Data/bd_definitiva.csv")
    country_info: Path = Path("Data/covid19countryinfo(4).csv")
    happiness: Path = Path("Data/World Happiness Report 2021.csv")
    renewables: Path = Path("Data/renewable-share-energy(2).csv")
    temperature: Path = Path("Data/temperaturas anuales.csv")
    suicides: Path = Path("Data/suicidios.csv")
    credibility: Path = Path("cred/data/credibilidades.txt")


def clean_numeric(series: pd.Series) -> pd.Series:
    """Turn strings such as ``"17.40%"`` or ``"$1,234"`` into floats."""
    cleaned = (
        series.astype("string")
        .str.replace(_NUMERIC_CLEAN_RE, "", regex=True)
        .str.replace(r"^N/A$", "", regex=True)
        .str.replace(r"^-$", "", regex=True)
        .str.strip()
    )
    cleaned = cleaned.replace({"": pd.NA, "nan": pd.NA, "None": pd.NA})
    return pd.to_numeric(cleaned, errors="coerce")


def load_raw_dataset(path: str | Path = DatasetPaths.raw) -> pd.DataFrame:
    """Load ``Data/bd_definitiva.csv`` as a clean, numeric, wide table."""
    path = Path(path)
    frame = pd.read_csv(path)
    frame.columns = [column.strip() for column in frame.columns]

    missing = [
        variable.raw_column for variable in VARIABLES if variable.raw_column not in frame.columns
    ]
    if missing:
        raise ValueError(f"{path} is missing columns: {missing}")

    frame = frame.rename(
        columns={
            "Country_number": "country_id",
            "Country_name": "country",
            **RAW_COLUMNS,
        }
    )
    expected = list(_ID_COLUMNS) + [variable.name for variable in VARIABLES]
    frame = frame[expected].copy()
    frame["country"] = frame["country"].astype(str).str.strip()
    frame["country_id"] = pd.to_numeric(frame["country_id"], errors="raise").astype(int)

    for variable in VARIABLES:
        frame[variable.name] = clean_numeric(frame[variable.name])

    if frame["country"].duplicated().any():
        duplicates = frame.loc[frame["country"].duplicated(), "country"].tolist()
        raise ValueError(f"Duplicated countries in {path}: {duplicates}")
    return frame.sort_values("country_id").reset_index(drop=True)


def build_scaled_dataset(model: FuzzyModel) -> pd.DataFrame:
    """Return the integer values stored in ``code.pl`` as a wide table."""
    rows: list[dict[str, object]] = []
    for country in sorted(model.countries.values(), key=lambda item: item.number):
        row: dict[str, object] = {
            "country_id": country.number,
            "country": country.name,
        }
        row.update({variable.name: country.value(variable.name) for variable in VARIABLES})
        rows.append(row)
    return pd.DataFrame(rows)


def audit_scaled_dataset(
    raw: pd.DataFrame,
    scaled: pd.DataFrame,
    model: FuzzyModel,
) -> pd.DataFrame:
    """Compare raw * 10**scale with the integer values used by the model.

    A row is flagged when the difference is larger than what rounding to an
    integer can explain.  These flags document known inconsistencies in the
    historical data; they are not fixed automatically because the published
    results were computed from the current ``code.pl`` values.
    """
    raw_by_country = raw.set_index("country")
    scaled_by_country = scaled.set_index("country")
    records: list[dict[str, object]] = []

    for variable in VARIABLES:
        factor = 10**variable.scale_exponent
        for country_id, country in zip(
            scaled_by_country["country_id"], scaled_by_country.index, strict=True
        ):
            if country not in raw_by_country.index:
                continue
            raw_value = raw_by_country.at[country, variable.name]
            scaled_value = scaled_by_country.at[country, variable.name]
            if pd.isna(raw_value):
                records.append(
                    {
                        "country_id": int(country_id),
                        "country": country,
                        "variable": variable.name,
                        "raw_value": None,
                        "scaled_value": scaled_value,
                        "expected_scaled": None,
                        "difference": None,
                        "scale_exponent": variable.scale_exponent,
                        "issue": "missing raw value",
                    }
                )
                continue

            expected = float(raw_value) * factor
            difference = float(scaled_value) - expected
            close = math.isclose(float(scaled_value), expected, rel_tol=1e-9, abs_tol=0.51)
            if not close:
                records.append(
                    {
                        "country_id": int(country_id),
                        "country": country,
                        "variable": variable.name,
                        "raw_value": float(raw_value),
                        "scaled_value": float(scaled_value),
                        "expected_scaled": expected,
                        "difference": difference,
                        "scale_exponent": variable.scale_exponent,
                        "issue": "scaled value does not match raw value",
                    }
                )

    columns = [
        "country_id",
        "country",
        "variable",
        "raw_value",
        "scaled_value",
        "expected_scaled",
        "difference",
        "scale_exponent",
        "issue",
    ]
    return pd.DataFrame(records, columns=columns)


def load_country_codes(
    path: str | Path = DatasetPaths.country_info,
    countries: set[str] | None = None,
) -> pd.DataFrame:
    """Load ISO codes and regions from the COVID-19 country info dataset."""
    frame = pd.read_csv(path)
    frame.columns = [column.strip() for column in frame.columns]
    required = ["country", "alpha3code", "alpha2code", "region"]
    missing = set(required) - set(frame.columns)
    if missing:
        raise ValueError(f"{path} is missing columns: {sorted(missing)}")
    frame = frame[required].copy()
    frame = frame.rename(columns={"alpha3code": "iso3", "alpha2code": "iso2"})
    frame["country"] = frame["country"].astype(str).str.strip()
    frame = frame.drop_duplicates(subset="country")
    if countries is not None:
        frame = frame[frame["country"].isin(countries)].copy()
    return frame.reset_index(drop=True)


def load_happiness(
    path: str | Path = DatasetPaths.happiness,
    countries: set[str] | None = None,
) -> pd.DataFrame:
    """Load the 2021 World Happiness Report and add a rank column."""
    frame = pd.read_csv(path)
    frame.columns = [column.strip() for column in frame.columns]
    if countries is not None:
        frame = frame[frame["Country name"].isin(countries)].copy()
    frame = frame.rename(
        columns={
            "Country name": "country",
            "Regional indicator": "region",
            "Ladder score": "ladder_score",
            "Standard error of ladder score": "ladder_score_std_error",
            "Logged GDP per capita": "log_gdp_per_capita",
            "Social support": "social_support",
            "Healthy life expectancy": "healthy_life_expectancy",
            "Freedom to make life choices": "freedom",
            "Generosity": "generosity",
            "Perceptions of corruption": "perceptions_of_corruption",
        }
    )
    keep = [
        "country",
        "region",
        "ladder_score",
        "ladder_score_std_error",
        "log_gdp_per_capita",
        "social_support",
        "healthy_life_expectancy",
        "freedom",
        "generosity",
        "perceptions_of_corruption",
    ]
    frame = frame[keep].copy()
    frame["rank"] = frame["ladder_score"].rank(ascending=False, method="min").astype(int)
    return frame.sort_values("rank").reset_index(drop=True)


def _with_country_ids(
    frame: pd.DataFrame, country_ids: dict[str, int], value_column: str
) -> pd.DataFrame:
    frame = frame[frame["country"].isin(country_ids)].copy()
    frame["country_id"] = frame["country"].map(country_ids).astype(int)
    frame = frame.rename(columns={value_column: "value"})
    return frame[["country_id", "country", "year", "value"]]


def load_renewables(
    path: str | Path = DatasetPaths.renewables,
    country_ids: dict[str, int] | None = None,
) -> pd.DataFrame:
    """Annual renewable energy share (1965-2021)."""
    country_ids = country_ids or {}
    frame = pd.read_csv(path)
    frame = frame.rename(
        columns={
            "Entity": "country",
            "Year": "year",
            "Renewables (% equivalent primary energy)": "renewables",
        }
    )
    frame = frame[["country", "year", "renewables"]].dropna()
    frame = _with_country_ids(frame, country_ids, "renewables")
    frame["indicator_id"] = "renewables"
    frame["source"] = "renewable-share-energy(2).csv"
    return frame.sort_values(["country", "year"]).reset_index(drop=True)


def load_temperature(
    path: str | Path = DatasetPaths.temperature,
    country_ids: dict[str, int] | None = None,
) -> pd.DataFrame:
    """Annual mean surface temperature (1901-2022)."""
    country_ids = country_ids or {}
    frame = pd.read_csv(path)
    frame = frame.rename(
        columns={"Country": "country", "Year": "year", "Annual Mean": "temperature"}
    )
    frame = frame[["country", "year", "temperature"]].dropna()
    frame = _with_country_ids(frame, country_ids, "temperature")
    frame["indicator_id"] = "surface_temperature"
    frame["source"] = "temperaturas anuales.csv"
    return frame.sort_values(["country", "year"]).reset_index(drop=True)


def load_suicides(
    path: str | Path = DatasetPaths.suicides,
    country_ids: dict[str, int] | None = None,
) -> pd.DataFrame:
    """Suicide rate per 100,000 people (2000-2019, both sexes)."""
    country_ids = country_ids or {}
    frame = pd.read_csv(path)
    frame = frame[
        (frame["DIM_SEX"] == "Total")
        & (frame["DIM_AGE"] == "Total years")
        & (frame["DIM_VALUE_TYPE"] == "RATE_PER_100000")
    ]
    frame = frame.rename(
        columns={
            "GEO_NAME_SHORT": "country",
            "DIM_TIME": "year",
            "VALUE_NUMERIC": "suicides",
        }
    )
    frame = frame[["country", "year", "suicides"]].dropna()
    frame = _with_country_ids(frame, country_ids, "suicides")
    frame["indicator_id"] = "suicides"
    frame["source"] = "suicidios.csv"
    return frame.sort_values(["country", "year"]).reset_index(drop=True)


def load_indicator_history(
    country_ids: dict[str, int],
    paths: DatasetPaths | None = None,
) -> pd.DataFrame:
    """Combine the three indicators that have a usable yearly series."""
    paths = paths or DatasetPaths()
    frames = [
        load_renewables(paths.renewables, country_ids),
        load_temperature(paths.temperature, country_ids),
        load_suicides(paths.suicides, country_ids),
    ]
    combined = pd.concat(frames, ignore_index=True)
    return combined[["country_id", "country", "indicator_id", "year", "value", "source"]]


def load_credibility(
    path: str | Path = DatasetPaths.credibility,
) -> pd.DataFrame:
    """Read the ``function: credibility`` file produced by the legacy pipeline."""
    path = Path(path)
    records: list[dict[str, object]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or ":" not in line:
            continue
        function, value = line.split(":", 1)
        records.append(
            {
                "function": function.strip(),
                "credibility": float(value.strip()),
            }
        )
    frame = pd.DataFrame(records, columns=["function", "credibility"])
    frame["mae"] = 1.0 - frame["credibility"]
    return frame


def write_processed_datasets(
    raw: pd.DataFrame,
    scaled: pd.DataFrame,
    audit: pd.DataFrame,
    out_dir: str | Path = "Data/processed",
) -> dict[str, Path]:
    """Write the processed tables used by the export and by analysts."""
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    outputs = {
        "countries_raw": out_dir / "countries_raw.csv",
        "countries_scaled": out_dir / "countries_scaled.csv",
        "data_quality": out_dir / "data_quality.csv",
    }
    raw.to_csv(outputs["countries_raw"], index=False)
    scaled.to_csv(outputs["countries_scaled"], index=False)
    audit.to_csv(outputs["data_quality"], index=False)

    if audit.empty:
        summary = pd.DataFrame(columns=["variable", "flagged_rows"])
    else:
        summary = (
            audit.groupby("variable", as_index=False)
            .size()
            .rename(columns={"size": "flagged_rows"})
            .sort_values(["flagged_rows", "variable"], ascending=[False, True])
        )
    summary.to_csv(out_dir / "data_quality_summary.csv", index=False)
    return outputs
