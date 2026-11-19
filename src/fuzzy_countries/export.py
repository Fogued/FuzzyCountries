"""Export the model as a Power BI-friendly star schema.

The output is intentionally simple: plain CSV files with stable English column
names, integer surrogate keys and no Power Query transformations required
beyond ``Data > Get data > Text/CSV``.

Run it with::

    fuzzy-countries export --out exports
"""

from __future__ import annotations

import json
from pathlib import Path

import pandas as pd

from .dataset import (
    DatasetPaths,
    audit_scaled_dataset,
    build_scaled_dataset,
    load_country_codes,
    load_credibility,
    load_happiness,
    load_indicator_history,
    load_raw_dataset,
)
from .model import FuzzyModel
from .variables import RULE_DESCRIPTIONS, VARIABLES


def _function_by_variable(model: FuzzyModel) -> dict[str, str]:
    mapping: dict[str, list[str]] = {}
    for function in model.functions.values():
        mapping.setdefault(function.variable, []).append(function.name)
    return {variable: "; ".join(sorted(names)) for variable, names in mapping.items()}


def _breakpoints_by_variable(model: FuzzyModel) -> dict[str, str]:
    mapping: dict[str, str] = {}
    for function in model.functions.values():
        mapping[function.variable] = json.dumps(
            [[x, y] for x, y in function.points], separators=(",", ":")
        )
    return mapping


def _variables_used_in_rules(model: FuzzyModel) -> set[str]:
    functions = {function.name: function for function in model.functions.values()}
    used: set[str] = set()
    for rule in model.rules.values():
        for component in rule.components:
            used.add(functions[component.function].variable)
    return used


def build_dim_country(
    model: FuzzyModel,
    raw: pd.DataFrame,
    codes: pd.DataFrame,
    regions: dict[str, str] | None = None,
) -> pd.DataFrame:
    countries = pd.DataFrame(
        [
            {"country_id": country.number, "country": country.name}
            for country in model.countries.values()
        ]
    ).sort_values("country_id")
    coordinates = (
        raw[["country", "latitude", "longitude"]]
        .rename(columns={"latitude": "latitude", "longitude": "longitude"})
        .drop_duplicates(subset="country")
    )
    frame = countries.merge(coordinates, on="country", how="left")
    frame = frame.merge(codes, on="country", how="left")
    if regions:
        from_happiness = frame["country"].map(regions)
        frame["region"] = from_happiness.where(from_happiness.notna(), frame["region"])
    frame["iso3"] = frame["iso3"].fillna("")
    frame["iso2"] = frame["iso2"].fillna("")
    frame["region"] = frame["region"].fillna("")
    return frame[["country_id", "country", "iso3", "iso2", "region", "latitude", "longitude"]]


def build_dim_indicator(model: FuzzyModel) -> pd.DataFrame:
    functions = _function_by_variable(model)
    breakpoints = _breakpoints_by_variable(model)
    used = _variables_used_in_rules(model)
    rows = []
    for variable in VARIABLES:
        rows.append(
            {
                "indicator_id": variable.name,
                "indicator": variable.name,
                "label": variable.label,
                "unit": variable.unit,
                "category": variable.category,
                "scale_exponent": variable.scale_exponent,
                "source": variable.source,
                "description": variable.description,
                "function_id": functions.get(variable.name, ""),
                "breakpoints": breakpoints.get(variable.name, "[]"),
                "used_in_rules": variable.name in used,
            }
        )
    return pd.DataFrame(rows)


def build_dim_rule(model: FuzzyModel) -> pd.DataFrame:
    return pd.DataFrame(
        [
            {
                "rule_id": rule.name,
                "rule": rule.name,
                "description": RULE_DESCRIPTIONS.get(rule.name, ""),
                "aggregation": rule.aggregation,
                "credibility_threshold": rule.credibility,
                "component_count": len(rule.components),
            }
            for rule in sorted(model.rules.values(), key=lambda item: item.name)
        ]
    )


def build_bridge_rule_indicator(model: FuzzyModel) -> pd.DataFrame:
    functions = {function.name: function for function in model.functions.values()}
    rows = []
    for rule in sorted(model.rules.values(), key=lambda item: item.name):
        for component in rule.components:
            function = functions[component.function]
            rows.append(
                {
                    "rule_id": rule.name,
                    "indicator_id": function.variable,
                    "function_id": function.name,
                    "negated": component.negated,
                }
            )
    return pd.DataFrame(rows)


def build_fact_indicator_value(
    model: FuzzyModel,
    raw: pd.DataFrame,
    scaled: pd.DataFrame,
    audit: pd.DataFrame,
) -> pd.DataFrame:
    functions = _function_by_variable(model)
    truth_by_country = {country: model.function_values(country) for country in model.countries}
    function_name_by_variable = {
        variable: name.split(";")[0].strip() for variable, name in functions.items() if name
    }
    quality = audit.set_index(["country", "variable"])[
        ["issue", "expected_scaled", "difference"]
    ].to_dict("index")

    raw_by_country = raw.set_index("country")
    scaled_by_country = scaled.set_index("country")
    rows = []
    for country_id, country in zip(
        scaled_by_country["country_id"], scaled_by_country.index, strict=True
    ):
        for variable in VARIABLES:
            raw_value = raw_by_country.at[country, variable.name]
            scaled_value = scaled_by_country.at[country, variable.name]
            function_name = function_name_by_variable.get(variable.name)
            truth_value = truth_by_country[country][function_name] if function_name else None
            record = quality.get((country, variable.name), {})
            issue = record.get("issue", "")
            expected = record.get("expected_scaled")
            difference = record.get("difference")
            rows.append(
                {
                    "country_id": int(country_id),
                    "country": country,
                    "indicator_id": variable.name,
                    "raw_value": float(raw_value) if pd.notna(raw_value) else None,
                    "scaled_value": float(scaled_value),
                    "expected_scaled": float(expected) if pd.notna(expected) else None,
                    "difference": float(difference) if pd.notna(difference) else None,
                    "truth_value": truth_value,
                    "is_consistent": not bool(issue),
                    "data_quality_issue": issue if issue else "OK",
                }
            )
    return pd.DataFrame(rows)


def build_fact_rule_result(model: FuzzyModel) -> pd.DataFrame:
    rows = []
    for country, scores in model.evaluate_all().items():
        country_id = model.countries[country].number
        for rule, score in scores.items():
            rows.append(
                {
                    "country_id": country_id,
                    "country": country,
                    "rule_id": rule,
                    "truth_value": float(score),
                }
            )
    frame = pd.DataFrame(rows)
    frame["rank"] = (
        frame.groupby("rule_id")["truth_value"].rank(ascending=False, method="min").astype(int)
    )
    return frame.sort_values(["rule_id", "rank"]).reset_index(drop=True)


def build_fact_credibility(model: FuzzyModel, path: str | Path | None = None) -> pd.DataFrame:
    credibility = load_credibility(path) if path is not None else load_credibility()
    if credibility.empty:
        return credibility
    functions = {function.name: function for function in model.functions.values()}
    credibility["indicator_id"] = credibility["function"].map(
        lambda name: functions[name].variable if name in functions else ""
    )
    credibility["indicator"] = credibility["indicator_id"].map(
        {variable.name: variable.label for variable in VARIABLES}
    )
    return credibility[["function", "indicator_id", "indicator", "credibility", "mae"]].sort_values(
        ["credibility", "function"], ascending=[False, True]
    )


def build_fact_happiness(
    model: FuzzyModel,
    path: str | Path | None = None,
    frame: pd.DataFrame | None = None,
) -> pd.DataFrame:
    happiness = (
        frame if frame is not None else load_happiness(path, countries=set(model.countries))
    ).copy()
    country_ids = {name: record.number for name, record in model.countries.items()}
    happiness.insert(0, "country_id", happiness["country"].map(country_ids).astype(int))
    happiness.insert(2, "year", 2021)
    return happiness[
        [
            "country_id",
            "country",
            "year",
            "region",
            "rank",
            "ladder_score",
            "ladder_score_std_error",
            "log_gdp_per_capita",
            "social_support",
            "healthy_life_expectancy",
            "freedom",
            "generosity",
            "perceptions_of_corruption",
        ]
    ]


def _write_readme(out_dir: Path, outputs: dict[str, Path]) -> Path:
    lines = [
        "# Power BI export",
        "",
        "Generated by `fuzzy-countries export`.",
        "",
        "| File | Rows | Purpose |",
        "| --- | ---: | --- |",
    ]
    purposes = {
        "dim_country": "One row per country (ISO codes, region, coordinates).",
        "dim_indicator": "Indicator metadata, units, scale and membership function.",
        "dim_rule": "The 17 active fuzzy rules and their descriptions.",
        "bridge_rule_indicator": "Many-to-many bridge between rules and indicators.",
        "fact_indicator_value": "Raw/scaled values and membership truth values.",
        "fact_rule_result": "Truth value and rank of every country for every rule.",
        "fact_function_credibility": "Credibility (1 - MAE) of each fuzzy function.",
        "fact_happiness": "World Happiness Report 2021 benchmark.",
        "fact_indicator_history": "Yearly series for renewables, temperature and suicides.",
    }
    for name, path in outputs.items():
        rows = sum(1 for _ in path.open(encoding="utf-8")) - 1
        lines.append(f"| `{path.name}` | {rows} | {purposes.get(name, '')} |")
    lines += [
        "",
        "## Import into Power BI Desktop",
        "",
        "1. `Get data > Text/CSV` for each file, using *Transform Data*.",
        "2. Set `country_id`, `indicator_id`, `rule_id` and `year` to **Whole number**.",
        "3. Create the relationships shown in `docs/powerbi.md`.",
        "4. Copy the measures from `dax/measures.dax` (repository root).",
        "",
        "The CSVs are UTF-8 and use English column names, so they can also be",
        "loaded into Excel, DuckDB or a notebook without changes.",
        "",
    ]
    path = out_dir / "README.md"
    path.write_text("\n".join(lines), encoding="utf-8")
    return path


def export_bi_tables(
    model: FuzzyModel,
    paths: DatasetPaths | None = None,
    out_dir: str | Path = "exports",
    *,
    include_history: bool = True,
) -> dict[str, Path]:
    """Write the complete star schema and return the generated paths."""
    paths = paths or DatasetPaths()
    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    raw = load_raw_dataset(paths.raw)
    scaled = build_scaled_dataset(model)
    audit = audit_scaled_dataset(raw, scaled, model)
    codes = load_country_codes(paths.country_info, countries=set(model.countries))
    happiness = load_happiness(paths.happiness, countries=set(model.countries))
    regions = happiness.set_index("country")["region"].to_dict()

    outputs: dict[str, Path] = {}

    def save(name: str, frame: pd.DataFrame) -> None:
        path = out_dir / f"{name}.csv"
        frame.to_csv(path, index=False, encoding="utf-8")
        outputs[name] = path

    save("dim_country", build_dim_country(model, raw, codes, regions))
    save("dim_indicator", build_dim_indicator(model))
    save("dim_rule", build_dim_rule(model))
    save("bridge_rule_indicator", build_bridge_rule_indicator(model))
    save("fact_indicator_value", build_fact_indicator_value(model, raw, scaled, audit))
    save("fact_rule_result", build_fact_rule_result(model))
    save("fact_function_credibility", build_fact_credibility(model, paths.credibility))
    save("fact_happiness", build_fact_happiness(model, frame=happiness))

    if include_history:
        country_ids = {name: record.number for name, record in model.countries.items()}
        history = load_indicator_history(country_ids, paths)
        save("fact_indicator_history", history)

    outputs["readme"] = _write_readme(out_dir, outputs)
    return outputs
