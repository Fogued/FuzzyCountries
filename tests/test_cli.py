"""Smoke tests for the command-line interface."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

from fuzzy_countries.cli import main


def _code(repo_root: Path) -> str:
    return str(repo_root / "code.pl")


def test_summary_and_validate(repo_root: Path, capsys) -> None:
    assert main(["--code", _code(repo_root), "summary"]) == 0
    output = capsys.readouterr().out
    assert "Countries: 49" in output
    assert "Indicators: 28" in output
    assert "Active rules: 17" in output

    assert main(["--code", _code(repo_root), "validate"]) == 0
    assert "Model is valid." in capsys.readouterr().out


def test_rank(repo_root: Path, capsys) -> None:
    assert main(["--code", _code(repo_root), "rank", "clean_country", "--top", "3"]) == 0
    output = capsys.readouterr().out
    assert "Iceland" in output
    assert "Norway" in output
    assert "Denmark" in output


def test_audit(repo_root: Path, capsys) -> None:
    raw = str(repo_root / "Data/bd_definitiva.csv")
    assert main(["--code", _code(repo_root), "audit", "--raw", raw]) == 0
    output = capsys.readouterr().out
    assert "Found 8 inconsistencies" in output
    assert "Algeria" in output


def test_build_data(repo_root: Path, tmp_path: Path, capsys) -> None:
    raw = str(repo_root / "Data/bd_definitiva.csv")
    out = tmp_path / "processed"
    assert (
        main(
            [
                "--code",
                _code(repo_root),
                "build-data",
                "--raw",
                raw,
                "--out",
                str(out),
            ]
        )
        == 0
    )
    assert (out / "countries_raw.csv").exists()
    assert (out / "countries_scaled.csv").exists()
    assert (out / "data_quality.csv").exists()
    assert "Wrote processed datasets" in capsys.readouterr().out


def test_export_no_history(repo_root: Path, tmp_path: Path, capsys) -> None:
    out = tmp_path / "exports"
    args = [
        "--code",
        _code(repo_root),
        "export",
        "--out",
        str(out),
        "--raw",
        str(repo_root / "Data/bd_definitiva.csv"),
        "--country-info",
        str(repo_root / "Data/covid19countryinfo(4).csv"),
        "--happiness",
        str(repo_root / "Data/World Happiness Report 2021.csv"),
        "--credibility",
        str(repo_root / "cred/data/credibilidades.txt"),
        "--no-history",
    ]
    assert main(args) == 0
    assert (out / "dim_country.csv").exists()
    assert (out / "fact_rule_result.csv").exists()
    assert not (out / "fact_indicator_history.csv").exists()
    frame = pd.read_csv(out / "fact_rule_result.csv")
    assert len(frame) == 49 * 17
    assert "Exported" in capsys.readouterr().out
