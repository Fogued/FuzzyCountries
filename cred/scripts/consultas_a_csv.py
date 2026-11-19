"""Turn the ``*_resultados.txt`` files produced by the Ciao binary into a CSV."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

DATA_DIR = Path(__file__).resolve().parent.parent / "data"


def get_archivos_resultados(data_dir: str | Path = DATA_DIR) -> list[Path]:
    """Return the result files in deterministic order."""
    return sorted(Path(data_dir).glob("*_resultados.txt"))


def leer_archivo_como_diccionario(archivo: str | Path) -> dict[str, str]:
    """Read a ``key: value`` file, skipping blank or malformed lines."""
    dictionary: dict[str, str] = {}
    with Path(archivo).open(encoding="utf-8") as handle:
        for line in handle:
            line = line.strip()
            if not line or ": " not in line:
                continue
            key, value = line.split(": ", 1)
            dictionary[key.strip()] = value.strip()
    return dictionary


def combinar_diccionarios_en_dataframe(
    diccionarios: list[dict[str, str]],
    nombres_archivos: list[str],
) -> pd.DataFrame:
    """Combine one dictionary per rule into a country x rule table."""
    frame = pd.DataFrame(diccionarios).T
    frame.columns = nombres_archivos
    return frame.reindex(sorted(frame.index))


def consultas_a_csv(
    data_dir: str | Path = DATA_DIR,
    output: str | Path | None = None,
) -> Path:
    """Read every ``*_resultados.txt`` file and write ``valores_verdad.csv``."""
    data_dir = Path(data_dir)
    archivos = get_archivos_resultados(data_dir)
    if not archivos:
        raise FileNotFoundError(
            f"No *_resultados.txt files found in {data_dir}. "
            "Run the Ciao queries first or pass --data-dir."
        )

    diccionarios = [leer_archivo_como_diccionario(archivo) for archivo in archivos]
    nombres_columnas = [archivo.name.removesuffix("_resultados.txt") for archivo in archivos]
    frame = combinar_diccionarios_en_dataframe(diccionarios, nombres_columnas)

    destination = Path(output) if output is not None else data_dir / "valores_verdad.csv"
    frame.to_csv(destination, encoding="utf-8")
    return destination
