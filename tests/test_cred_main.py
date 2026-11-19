"""Integration test for the legacy ``cred/main.py`` entry point."""

from __future__ import annotations

from pathlib import Path

from cred.main import main


def _write_minimal_data(data_dir: Path) -> None:
    data_dir.mkdir(parents=True)
    (data_dir / "bdd_int.csv").write_text(
        "Country_number,Country_name,Libertad Economica,medianage\n"
        "0,'Algeria'  ,482 ,29).\n"
        "1,'Argentina',477 ,32).\n",
        encoding="utf-8",
    )
    (data_dir / "mapa_columnas_funciones.txt").write_text(
        "Libertad Economica: high_economic_freedom\n", encoding="utf-8"
    )
    (data_dir / "high_economic_freedom_resultados.txt").write_text(
        "Algeria: 1.0\nArgentina: 0.0\n", encoding="utf-8"
    )


def test_main_skip_queries(tmp_path: Path, capsys) -> None:
    data_dir = tmp_path / "data"
    _write_minimal_data(data_dir)

    assert main(["--skip-queries", "--data-dir", str(data_dir)]) == 0
    output = capsys.readouterr().out
    assert "Starting credibility pipeline" in output
    assert "Done" in output

    credibility = (data_dir / "credibilidades.txt").read_text(encoding="utf-8")
    assert "high_economic_freedom: 1.0" in credibility
    assert not (data_dir / "valores_verdad.csv").exists()
    assert not (data_dir / "bdd_normalizada.csv").exists()
    assert not list(data_dir.glob("*_resultados.txt"))


def test_main_keep_intermediate(tmp_path: Path) -> None:
    data_dir = tmp_path / "data"
    _write_minimal_data(data_dir)

    assert (
        main(
            [
                "--skip-queries",
                "--data-dir",
                str(data_dir),
                "--keep-intermediate",
            ]
        )
        == 0
    )
    assert (data_dir / "valores_verdad.csv").exists()
    assert (data_dir / "bdd_normalizada.csv").exists()
    assert (data_dir / "high_economic_freedom_resultados.txt").exists()
