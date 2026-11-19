"""Tests for data loading, cleaning and quality checks."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

from fuzzy_countries import FuzzyModel
from fuzzy_countries.dataset import (
    DatasetPaths,
    audit_scaled_dataset,
    build_scaled_dataset,
    clean_numeric,
    load_country_codes,
    load_credibility,
    load_happiness,
    load_indicator_history,
    load_renewables,
    load_suicides,
    load_temperature,
    write_processed_datasets,
)
from fuzzy_countries.variables import VARIABLES


def test_clean_numeric_handles_formatted_strings() -> None:
    series = pd.Series(["17.40%", "$1,234", " 42 ", "N/A", "-", ""])
    cleaned = clean_numeric(series)
    assert cleaned.iloc[0] == 17.40
    assert cleaned.iloc[1] == 1234
    assert cleaned.iloc[2] == 42
    assert cleaned.iloc[3:].isna().all()


def test_raw_dataset_shape_and_columns(raw_dataset, model: FuzzyModel) -> None:
    assert raw_dataset.shape == (49, 30)
    assert raw_dataset["country_id"].is_unique
    assert raw_dataset["country"].is_unique
    assert list(raw_dataset.columns) == ["country_id", "country"] + [
        variable.name for variable in VARIABLES
    ]
    assert set(raw_dataset["country"]) == set(model.countries)


def test_scaled_dataset_matches_model(model: FuzzyModel) -> None:
    scaled = build_scaled_dataset(model)
    assert scaled.shape == (49, 30)
    algeria = scaled[scaled["country"] == "Algeria"].iloc[0]
    assert algeria["economic_freedom_index"] == 482
    assert algeria["surface_temperature"] == 2392


def test_audit_flags_known_inconsistencies(raw_dataset, model: FuzzyModel) -> None:
    scaled = build_scaled_dataset(model)
    audit = audit_scaled_dataset(raw_dataset, scaled, model)
    flagged = set(zip(audit["country"], audit["variable"], strict=True))
    assert ("Algeria", "unemployment") in flagged
    assert ("Algeria", "renewables") in flagged
    assert ("Canada", "surface_temperature") in flagged
    assert ("Luxembourg", "median_age") in flagged


def test_auxiliary_datasets(repo_root: Path, model: FuzzyModel) -> None:
    country_ids = {name: record.number for name, record in model.countries.items()}
    paths = DatasetPaths(
        raw=repo_root / "Data/bd_definitiva.csv",
        country_info=repo_root / "Data/covid19countryinfo(4).csv",
        happiness=repo_root / "Data/World Happiness Report 2021.csv",
        renewables=repo_root / "Data/renewable-share-energy(2).csv",
        temperature=repo_root / "Data/temperaturas anuales.csv",
        suicides=repo_root / "Data/suicidios.csv",
        credibility=repo_root / "cred/data/credibilidades.txt",
    )

    codes = load_country_codes(paths.country_info, countries=set(model.countries))
    assert len(codes) == 49
    assert codes["iso3"].notna().all()

    happiness = load_happiness(paths.happiness, countries=set(model.countries))
    assert len(happiness) == 49
    assert happiness["rank"].between(1, 49).all()
    assert happiness["ladder_score"].is_monotonic_decreasing
    assert happiness["region"].notna().all()

    renewables = load_renewables(paths.renewables, country_ids)
    temperature = load_temperature(paths.temperature, country_ids)
    suicides = load_suicides(paths.suicides, country_ids)
    assert not renewables.empty and renewables["year"].min() == 1965
    assert not temperature.empty and temperature["year"].min() == 1901
    assert not suicides.empty and suicides["year"].min() == 2000

    history = load_indicator_history(country_ids, paths)
    assert set(history["indicator_id"]) == {
        "renewables",
        "surface_temperature",
        "suicides",
    }
    assert history["country_id"].nunique() == 49

    credibility = load_credibility(paths.credibility)
    assert len(credibility) == 26
    assert credibility["credibility"].between(0, 1).all()


def test_write_processed_datasets(tmp_path: Path, raw_dataset, model: FuzzyModel) -> None:
    scaled = build_scaled_dataset(model)
    audit = audit_scaled_dataset(raw_dataset, scaled, model)
    outputs = write_processed_datasets(raw_dataset, scaled, audit, out_dir=tmp_path)
    assert all(path.exists() for path in outputs.values())
    assert (tmp_path / "countries_raw.csv").exists()
    assert (tmp_path / "countries_scaled.csv").exists()
    assert (tmp_path / "data_quality.csv").exists()
    assert (tmp_path / "data_quality_summary.csv").exists()
