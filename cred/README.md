# Credibility pipeline (legacy)

This folder contains the original Python pipeline that computes the credibility
of every fuzzy membership function:

```
truth value of the function  ──►  compare with the normalised real indicator
                                      credibility = 1 - MAE
```

## Requirements

- Python 3.10+ with `pandas` and `scikit-learn` (see `requirements.txt`).
- The Ciao Prolog binary `src/consultar` (Linux ELF) for the query step.

## Run

From the repository root:

```bash
python cred/main.py
```

If the `*_resultados.txt` files already exist (for example, generated in WSL),
process them without running the binary:

```bash
python cred/main.py --skip-queries --keep-intermediate
```

## Files

| File | Purpose |
| --- | --- |
| `data/funciones.txt` | One fuzzy function per line, queried by the Ciao binary. |
| `data/bdd_int.csv` | Historical integer export of the model data. |
| `data/mapa_columnas_funciones.txt` | Maps raw CSV columns to fuzzy function names. |
| `data/credibilidades.txt` | Output: `function: credibility` (0-1). |

## Notes

- On Windows the Ciao binary cannot run directly. Use WSL/Linux for the query
  step, or copy the `*_resultados.txt` files and use `--skip-queries`.
- The pipeline aligns countries by name before comparing series, so the
  credibility values are not affected by row order.
- `bdd_int.csv` keeps a few historical formatting artefacts (quotes around
  country names and a trailing `).` in the last column). `scripts/credibilidad.py`
  repairs them when loading the file.
