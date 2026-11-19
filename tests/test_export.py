"""Tests for the Power BI export."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

from fuzzy_countries import FuzzyModel
from fuzzy_countries.dataset import DatasetPaths
from fuzzy_countries.export import export_bi_tables


def _paths(repo_root: Path) -> DatasetPaths:
    return DatasetPaths(
        raw=repo_root / "Data/bd_definitiva.csv",
        country_info=repo_root / "Data/covid19countryinfo(4).csv",
        happiness=repo_root / "Data/World Happiness Report 2021.csv",
        renewables=repo_root / "Data/renewable-share-energy(2).csv",
        temperature=repo_root / "Data/temperaturas anuales.csv",
        suicides=repo_root / "Data/suicidios.csv",
        credibility=repo_root / "cred/data/credibilidades.txt",
    )


def test_export_files_and_shapes(tmp_path: Path, repo_root: Path, model: FuzzyModel) -> None:
    outputs = export_bi_tables(model, paths=_paths(repo_root), out_dir=tmp_path)
    assert len(outputs) == 10

    expected_rows = {
        "dim_country": 49,
        "dim_indicator": 28,
        "dim_rule": 17,
        "bridge_rule_indicator": 58,
        "fact_indicator_value": 49 * 28,
        "fact_rule_result": 49 * 17,
        "fact_function_credibility": 26,
        "fact_happiness": 49,
    }
    for name, rows in expected_rows.items():
        frame = pd.read_csv(tmp_path / f"{name}.csv")
        assert len(frame) == rows, name

    history = pd.read_csv(tmp_path / "fact_indicator_history.csv")
    assert len(history) > 9000
    assert set(history["indicator_id"]) == {
        "renewables",
        "surface_temperature",
        "suicides",
    }


def test_export_keys_and_relationships(tmp_path: Path, repo_root: Path, model: FuzzyModel) -> None:
    export_bi_tables(model, paths=_paths(repo_root), out_dir=tmp_path)

    country = pd.read_csv(tmp_path / "dim_country.csv")
    indicator = pd.read_csv(tmp_path / "dim_indicator.csv")
    rule = pd.read_csv(tmp_path / "dim_rule.csv")
    bridge = pd.read_csv(tmp_path / "bridge_rule_indicator.csv")
    results = pd.read_csv(tmp_path / "fact_rule_result.csv")
    values = pd.read_csv(tmp_path / "fact_indicator_value.csv")
    happiness = pd.read_csv(tmp_path / "fact_happiness.csv")

    assert country["country_id"].is_unique
    assert indicator["indicator_id"].is_unique
    assert rule["rule_id"].is_unique
    assert country["region"].notna().all()

    assert set(bridge["rule_id"]).issubset(set(rule["rule_id"]))
    assert set(bridge["indicator_id"]).issubset(set(indicator["indicator_id"]))
    assert set(results["country_id"]).issubset(set(country["country_id"]))
    assert set(results["rule_id"]).issubset(set(rule["rule_id"]))
    assert set(values["country_id"]).issubset(set(country["country_id"]))
    assert set(values["indicator_id"]).issubset(set(indicator["indicator_id"]))
    assert set(happiness["country_id"]).issubset(set(country["country_id"]))

    assert results["truth_value"].between(0, 1).all()
    assert results.groupby("rule_id")["rank"].min().eq(1).all()
    assert {"expected_scaled", "difference"}.issubset(values.columns)
    flagged = values[~values["is_consistent"]]
    assert len(flagged) == 8
    assert (
        flagged["data_quality_issue"]
        .isin(["missing raw value", "scaled value does not match raw value"])
        .all()
    )

    # Latitude/longitude have no membership function, so they have no truth value.
    # land_area and armed_forces_size do have functions, but no active rule uses them.
    unused = values[~values["indicator_id"].isin(bridge["indicator_id"])]
    assert set(unused["indicator_id"]) == {
        "land_area",
        "armed_forces_size",
        "latitude",
        "longitude",
    }
    assert (
        values[values["indicator_id"].isin(["latitude", "longitude"])]["truth_value"].isna().all()
    )
