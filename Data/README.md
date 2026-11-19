# Data folder

This folder mixes raw downloads, a curated table and historical one-off scripts.
Use the table below before editing anything.

## Canonical and curated data

| File | Role |
| --- | --- |
| `../code.pl` | **Canonical model input** (`country/30` facts). The Python engine reads this file directly. |
| `bd_definitiva.csv` | Curated 49 × 30 table with raw values (percentages as numbers after cleaning). Used for units, labels and the Power BI export. |
| `world-data-2023(1).csv` | Original Kaggle download. Do not edit. |
| `covid19countryinfo(4).csv` | ISO codes and country metadata. |
| `World Happiness Report 2021.csv` | Happiness benchmark and WHR regional indicator. |
| `renewable-share-energy(2).csv` | Yearly renewable share, 1965-2022. |
| `temperaturas anuales.csv` | Yearly mean temperature, 1901-2022. |
| `suicidios.csv` | WHO suicide rate, 2000-2019. |
| `minimum_wage(3).csv` | Minimum wage source. |
| `libertad_economica.csv`, `libertad_economica.xlsx`, `corrupcion.csv`, `temperatura_media.csv` | Intermediate/source extracts kept for provenance. |

## Generated data (gitignored)

`Data/processed/` is written by:

```bash
fuzzy-countries build-data --out Data/processed
```

It contains `countries_raw.csv`, `countries_scaled.csv`, `data_quality.csv`
and `data_quality_summary.csv`. Do not edit these files by hand; change the
source data or the model and regenerate them.

## Historical artefacts

| File | Status |
| --- | --- |
| `bdd_int.csv` | **Not a CSV.** It contains Prolog `country(...)` facts. It is unused by the current pipeline; `code.pl` is the source of truth. |
| `cleaned-all.csv` | Earlier merge of the raw sources. Superseded by `bd_definitiva.csv`. |
| `cleandata.py`, `cleandata-pancho.py`, `fix_db.py` | One-off cleaning scripts kept for provenance. They use hardcoded paths and are not part of the reproducible pipeline. |
| `../floatToInt.py` | One-off float → integer conversion. The current pipeline uses `src/fuzzy_countries` instead. |
| `vars_datasets.txt` | Notes about the original variable selection. |

The legacy credibility pipeline has its own data folder in
[`../cred/data`](../cred/data). `cred/data/bdd_int.csv` is a partially formatted
integer export; `cred/data/happy_1.csv` and `happy_2.csv` are byte-identical
duplicates.

## Adding a new source

1. Put the raw file in `Data/` with a descriptive name.
2. Add it to `src/fuzzy_countries/dataset.py` (`DatasetPaths` and a loader).
3. Add a test in `tests/test_dataset.py` that checks the 49-country match.
4. Document the units and scale in `docs/data_dictionary.md`.
5. Regenerate `Data/processed/` and `exports/`.
