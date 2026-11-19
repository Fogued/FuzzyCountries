"""Legacy credibility pipeline for the Ciao/RFuzzy model.

This entry point is kept for reproducibility of the original thesis.  It runs
the Linux-only ``src/consultar`` binary, converts the textual results to CSV
and computes the credibility of every membership function.

On Windows, run the queries in WSL or use ``--skip-queries`` if the
``*_resultados.txt`` files already exist.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from scripts.consultas_a_csv import consultas_a_csv
from scripts.credibilidad import hallar_credibilidades, normalizar_parametros

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_DATA_DIR = BASE_DIR / "data"
DEFAULT_BINARY = BASE_DIR / "src" / "consultar"
DEFAULT_FUNCTIONS = DEFAULT_DATA_DIR / "funciones.txt"


def ejecutar_consultas(
    data_dir: Path = DEFAULT_DATA_DIR,
    binary: Path = DEFAULT_BINARY,
    functions_file: Path = DEFAULT_FUNCTIONS,
) -> None:
    """Run one Ciao query per line of ``funciones.txt``.

    The compiled binary writes to a ``data/`` folder relative to its working
    directory, so ``data_dir`` must be named ``data`` and the process runs from
    its parent.  This keeps ``--data-dir`` consistent with the post-processing
    step.
    """
    if not binary.exists():
        raise SystemExit(
            f"Ciao binary not found: {binary}\n"
            "Run the queries from a Linux/WSL environment or use --skip-queries."
        )
    if sys.platform == "win32":
        raise SystemExit(
            "The bundled src/consultar binary is a Linux ELF executable.\n"
            "Run this step in WSL/Linux, or copy the *_resultados.txt files "
            "and use --skip-queries."
        )
    if data_dir.name != "data":
        raise SystemExit(
            "--data-dir must be a folder named 'data' when running the Ciao binary, "
            "or use --skip-queries."
        )
    if not functions_file.exists():
        raise SystemExit(f"Functions file not found: {functions_file}")

    data_dir.mkdir(parents=True, exist_ok=True)
    binary = binary.resolve()
    functions = [
        line.strip()
        for line in functions_file.read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.startswith("#")
    ]
    for function in functions:
        print(f"Querying {function}...")
        subprocess.run([str(binary), function], cwd=data_dir.parent, check=True)
    print("#" * 69)


def procesar_datos(data_dir: Path = DEFAULT_DATA_DIR, *, keep_intermediate: bool = False) -> None:
    """Build the truth-value table, normalise the data and compute credibility."""
    data_dir.mkdir(parents=True, exist_ok=True)
    consultas_a_csv(data_dir)
    if not keep_intermediate:
        for path in data_dir.glob("*_resultados.txt"):
            path.unlink()

    normalizar_parametros(data_dir)
    hallar_credibilidades(data_dir)

    if not keep_intermediate:
        for name in ("valores_verdad.csv", "bdd_normalizada.csv"):
            (data_dir / name).unlink(missing_ok=True)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run the legacy Ciao/RFuzzy credibility pipeline.")
    parser.add_argument(
        "--data-dir",
        type=Path,
        default=DEFAULT_DATA_DIR,
        help="Directory with funciones.txt and the generated CSVs.",
    )
    parser.add_argument(
        "--binary",
        type=Path,
        default=DEFAULT_BINARY,
        help="Path to the compiled consultar binary.",
    )
    parser.add_argument(
        "--functions",
        type=Path,
        default=None,
        help="File with one fuzzy function per line (default: <data-dir>/funciones.txt).",
    )
    parser.add_argument(
        "--skip-queries",
        action="store_true",
        help="Do not run the Ciao binary; process existing *_resultados.txt files.",
    )
    parser.add_argument(
        "--keep-intermediate",
        action="store_true",
        help="Keep valores_verdad.csv and bdd_normalizada.csv.",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    print("#" * 69)
    print("Starting credibility pipeline")
    print("#" * 69)
    functions = args.functions or (args.data_dir / "funciones.txt")
    if not args.skip_queries:
        ejecutar_consultas(args.data_dir, args.binary, functions)
    procesar_datos(args.data_dir, keep_intermediate=args.keep_intermediate)
    print("#" * 69)
    print("Done")
    print("#" * 69)
    return 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
