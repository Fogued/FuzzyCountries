"""Normalise the model output and compute the credibility of each function."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

from scripts.algoritmos import calcular_credibilidad, normalizar_valores
from scripts.consultas_a_csv import leer_archivo_como_diccionario

DATA_DIR = Path(__file__).resolve().parent.parent / "data"


def _clean_scaled_csv(path: str | Path) -> pd.DataFrame:
    """Read the legacy integer CSV and repair its historical formatting.

    ``bdd_int.csv`` was exported from Prolog by hand: country names keep the
    surrounding quotes and the last column ends with ``).``.  Cleaning here
    keeps the rest of the pipeline simple and makes the file usable with
    modern pandas.
    """
    frame = pd.read_csv(path)
    frame.columns = [column.strip() for column in frame.columns]
    for column in frame.columns:
        if column == "Country_name":
            frame[column] = frame[column].astype(str).str.strip().str.strip("'").str.strip()
        else:
            frame[column] = pd.to_numeric(
                frame[column].astype(str).str.replace(").", "", regex=False).str.strip(),
                errors="coerce",
            )
    return frame


def get_diccionario_normalizado(
    parametro: str, data_dir: str | Path = DATA_DIR
) -> dict[str, float]:
    """Return one min-max normalised indicator keyed by country name."""
    frame = _clean_scaled_csv(Path(data_dir) / "bdd_int.csv").set_index("Country_name")
    values = normalizar_valores(frame[parametro].tolist())
    return dict(zip(frame.index, values, strict=True))


def normalizar_parametros(
    data_dir: str | Path = DATA_DIR,
    output: str | Path | None = None,
) -> Path:
    """Normalise every numeric column of ``bdd_int.csv``."""
    data_dir = Path(data_dir)
    frame = _clean_scaled_csv(data_dir / "bdd_int.csv").set_index("Country_name")
    frame = frame.drop(
        columns=[
            column
            for column in ("Country_number", "Latitude", "Longitude")
            if column in frame.columns
        ]
    )

    for column in frame.columns:
        frame[column] = normalizar_valores(frame[column].tolist())

    frame.index = [str(country).strip().replace("'", "") for country in frame.index]
    destination = Path(output) if output is not None else data_dir / "bdd_normalizada.csv"
    frame.to_csv(destination, encoding="utf-8")
    return destination


def hallar_credibilidades(
    data_dir: str | Path = DATA_DIR,
    output: str | Path | None = None,
) -> dict[str, float]:
    """Compute ``1 - MAE`` for every function and write ``credibilidades.txt``."""
    data_dir = Path(data_dir)
    truth = pd.read_csv(data_dir / "valores_verdad.csv", index_col=0)
    normalised = pd.read_csv(data_dir / "bdd_normalizada.csv", index_col=0)
    truth.index = truth.index.astype(str).str.strip()
    normalised.index = normalised.index.astype(str).str.strip()
    common = truth.index.intersection(normalised.index)
    column_map = leer_archivo_como_diccionario(data_dir / "mapa_columnas_funciones.txt")

    credibilities: dict[str, float] = {}
    for column, function in column_map.items():
        if column not in normalised.columns or function not in truth.columns:
            continue
        credibilities[function] = calcular_credibilidad(
            truth.loc[common, function], normalised.loc[common, column]
        )

    destination = Path(output) if output is not None else data_dir / "credibilidades.txt"
    with destination.open("w", encoding="utf-8") as handle:
        for function, value in credibilities.items():
            handle.write(f"{function}: {value}\n")
    return credibilities
