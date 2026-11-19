"""Tests for the legacy result-file and credibility pipeline."""

from __future__ import annotations

from pathlib import Path

import pandas as pd
import pytest
from scripts.consultas_a_csv import (
    consultas_a_csv,
    get_archivos_resultados,
    leer_archivo_como_diccionario,
)
from scripts.credibilidad import (
    get_diccionario_normalizado,
    hallar_credibilidades,
    normalizar_parametros,
)


def _write_legacy_csv(path: Path) -> None:
    path.write_text(
        "Country_number,Country_name,Libertad Economica,medianage\n"
        "0,'Algeria'  ,482 ,29).\n"
        "1,'Argentina',477 ,32).\n",
        encoding="utf-8",
    )


def test_result_file_helpers(tmp_path: Path) -> None:
    (tmp_path / "clean_country_resultados.txt").write_text(
        "Algeria: 0.5\nArgentina: 0.25\n", encoding="utf-8"
    )
    (tmp_path / "developed_country_resultados.txt").write_text(
        "Algeria: 0.75\nArgentina: 0.9\n", encoding="utf-8"
    )

    files = get_archivos_resultados(tmp_path)
    assert [path.name for path in files] == [
        "clean_country_resultados.txt",
        "developed_country_resultados.txt",
    ]
    assert leer_archivo_como_diccionario(files[0]) == {
        "Algeria": "0.5",
        "Argentina": "0.25",
    }

    output = consultas_a_csv(tmp_path)
    frame = pd.read_csv(output, index_col=0)
    assert list(frame.columns) == ["clean_country", "developed_country"]
    assert list(frame.index) == ["Algeria", "Argentina"]
    assert frame.loc["Algeria", "developed_country"] == pytest.approx(0.75)


def test_legacy_csv_is_cleaned_and_normalised(tmp_path: Path) -> None:
    _write_legacy_csv(tmp_path / "bdd_int.csv")
    destination = normalizar_parametros(tmp_path)
    frame = pd.read_csv(destination, index_col=0)

    assert list(frame.index) == ["Algeria", "Argentina"]
    assert frame.loc["Algeria", "Libertad Economica"] == pytest.approx(1.0)
    assert frame.loc["Argentina", "Libertad Economica"] == pytest.approx(0.0)
    assert frame.loc["Algeria", "medianage"] == pytest.approx(0.0)
    assert frame.loc["Argentina", "medianage"] == pytest.approx(1.0)

    values = get_diccionario_normalizado("medianage", tmp_path)
    assert values["Algeria"] == pytest.approx(0.0)


def test_credibility_aligns_countries_by_name(tmp_path: Path) -> None:
    _write_legacy_csv(tmp_path / "bdd_int.csv")
    normalizar_parametros(tmp_path)
    pd.DataFrame(
        {
            "high_economic_freedom": [0.0, 1.0],
        },
        index=pd.Index(["Argentina", "Algeria"], name="country"),
    ).to_csv(tmp_path / "valores_verdad.csv", encoding="utf-8")
    (tmp_path / "mapa_columnas_funciones.txt").write_text(
        "Libertad Economica: high_economic_freedom\n", encoding="utf-8"
    )

    credibilities = hallar_credibilidades(tmp_path)
    assert credibilities["high_economic_freedom"] == pytest.approx(1.0)
    assert (tmp_path / "credibilidades.txt").exists()
