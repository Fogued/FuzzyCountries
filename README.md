# FuzzyCountries

**English** | [Español](README.es.md)

A fuzzy-logic socioeconomic model for 49 countries, originally developed as a
final degree project with **Ciao Prolog + RFuzzy**, plus a modern Python
toolchain that makes the model reproducible, testable and ready for Power BI.

[![CI](https://github.com/Fogued/FuzzyCountries/actions/workflows/ci.yml/badge.svg)](https://github.com/Fogued/FuzzyCountries/actions/workflows/ci.yml)
[![Python 3.10+](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## What is this?

The model answers questions such as *"which countries are developed?"* or
*"which countries have a clean energy profile?"* using fuzzy rules instead of a
single hard threshold. Each country is described by 28 indicators; 26
membership functions turn those indicators into truth values in `[0, 1]`; 17
rules combine them with the arithmetic mean. The result is a transparent score
per country and per rule.

The original implementation lives in [`code.pl`](code.pl). The Python package
in [`src/fuzzy_countries`](src/fuzzy_countries) parses that same file and
evaluates the same model, so you can run it on Windows, macOS or Linux without
the Ciao runtime.

## Results at a glance

| Rule | Top countries (reference implementation) |
| --- | --- |
| `clean_country` | Iceland 0.906 · Norway 0.805 · Denmark 0.792 |
| `developed_country` | Japan 0.889 · Germany 0.855 · France 0.832 · Spain 7th (0.796) |
| `economically_stable_country` | Thailand 0.722 · Japan 0.702 · Germany 0.647 |
| `quality_healthcare_country` | Japan 0.916 · Iceland 0.914 · Finland 0.910 · Spain 7th (0.897) |
| `political_stable_country` | New Zealand 0.877 · Denmark 0.865 · Switzerland 0.863 |

These are regression-tested in [`tests/test_model.py`](tests/test_model.py).
The values come from the current `code.pl` data, including the historical
inconsistencies documented in [`docs/data_quality.md`](docs/data_quality.md).

## Repository structure

```
code.pl                     Ciao Prolog + RFuzzy model (source of truth)
src/fuzzy_countries/        Python reference implementation and CLI
  model.py                  Parser + membership functions + rules
  dataset.py                Data cleaning, audit and time series
  export.py                 Power BI star-schema export
  variables.py              Indicator metadata (units, scale, source)
  cli.py                    `fuzzy-countries` command
tests/                      pytest suite (37 tests)
docs/                       Model, data dictionary, quality, Power BI guide
dax/measures.dax            Copy-paste DAX measures for the report
Data/                       Raw and intermediate datasets
cred/                       Legacy Ciao query + credibility pipeline
Consultas/                  Ciao queries and result notes
Memoria/, Presentation/     LaTeX report and slides
exports/                    Generated Power BI CSVs (gitignored)
```

## Quick start

### Python (recommended)

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

pip install -e ".[dev]"
```

Then:

```bash
fuzzy-countries summary
fuzzy-countries validate
fuzzy-countries rank clean_country --top 10
fuzzy-countries audit
fuzzy-countries export --out exports
fuzzy-countries build-data --out Data/processed
pytest
```

If the `fuzzy-countries` executable is not on your `PATH`, use
`python -m fuzzy_countries.cli ...` instead. On systems where pip cannot write
to the global `Scripts` directory, the `.venv` route avoids the problem.

### CLI reference

| Command | What it does |
| --- | --- |
| `fuzzy-countries summary` | Show 49 countries, 26 functions, 17 rules. |
| `fuzzy-countries validate` | Check the model for missing variables, unknown functions, out-of-range values. |
| `fuzzy-countries rank <rule> --top N` | Rank countries for one rule. |
| `fuzzy-countries audit` | Compare `Data/bd_definitiva.csv` with the integer values in `code.pl`. |
| `fuzzy-countries export --out exports` | Generate the Power BI star schema. |
| `fuzzy-countries build-data --out Data/processed` | Write cleaned raw/scaled tables and the quality report. |

## The model

- 49 countries, 28 indicators.
- 26 piecewise-linear membership functions.
- 17 active rules, all with `mean` aggregation and `fnot(x) = 1 - x`.
- 4 indicators are not used by active rules: `latitude` and `longitude` have no
  function; `land_area` and `armed_forces_size` have functions but no active
  rule.

See [`docs/model.md`](docs/model.md) for the complete function and rule tables,
the semantics and a worked example.

## Data

The model uses a 2021 snapshot of socioeconomic indicators. The raw table is
`Data/bd_definitiva.csv`; the canonical model values are the `country/30`
facts in `code.pl`. Sources include the World Data 2023 dataset (Kaggle), the
World Happiness Report 2021, WHO suicide data, Fraser Institute economic
freedom, and Kaggle renewable-energy/temperature series.

- Full units, scale factors and raw column names:
  [`docs/data_dictionary.md`](docs/data_dictionary.md).
- Known inconsistencies (8 rows) and why they are not silently fixed:
  [`docs/data_quality.md`](docs/data_quality.md).

The audit finds, among others, a sign error in Canada's temperature, a 10×
scaling error in Algeria's unemployment and renewables, a missing CPI for
Belarus, a missing tax revenue for Ecuador, and a median-age mismatch for
Luxembourg. The Python engine reproduces the published model **as coded**;
corrections should be intentional and accompanied by updated tests.

## Power BI

The export is a star schema:

| Dimension | Fact tables |
| --- | --- |
| `dim_country` | `fact_indicator_value`, `fact_rule_result`, `fact_happiness`, `fact_indicator_history` |
| `dim_indicator` | `fact_indicator_value`, `fact_function_credibility`, `fact_indicator_history`, `bridge_rule_indicator` |
| `dim_rule` | `fact_rule_result`, `bridge_rule_indicator` |

```bash
fuzzy-countries export --out exports
```

Then follow [`docs/powerbi.md`](docs/powerbi.md) for the import steps,
relationships, DAX measures and six suggested report pages (overview, rule
explorer, indicator detail, happiness benchmark, data quality, time series).
The export is plain UTF-8 CSV, so it also works in Excel, DuckDB or a notebook.

## Legacy Ciao pipeline

The original model and credibility pipeline are kept for reproducibility:

```bash
# Linux / WSL: run the Ciao queries + credibility calculation
python cred/main.py

# If *_resultados.txt already exist (e.g. generated in WSL):
python cred/main.py --skip-queries --keep-intermediate
```

`cred/README.md` explains the files and the Linux-only binary. The Python
reference implementation and the legacy pipeline are independent: the former
reads `code.pl`, the latter reads the historical `cred/data/bdd_int.csv`.

## Reproducibility and CI

- `pytest`: 37 tests covering the parser, interpolation, published rankings,
  data cleaning, audit, export keys/relationships, the CLI and the legacy
  credibility pipeline.
- `ruff check` and `ruff format --check`: linting and formatting.
- GitHub Actions runs the tests on Python 3.10, 3.11 and 3.12 (see
  [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).
- `fuzzy-countries validate` is a fast smoke test for the Prolog model.

## Limitations

- The model is a 2021 snapshot, not a time-series model. Only renewables,
  temperature and suicides have yearly series.
- The rule aggregation is an unweighted mean; there is no rule weighting or
  defuzzification step.
- A `0` minimum wage means "no statutory minimum", not a literal zero.
- Missing raw values and scaling inconsistencies are documented, not imputed.
- Fuzzy scores are relative to the 49-country universe; they are not absolute
  country rankings.

## Contributing

1. Create a branch and a virtual environment.
2. Change `code.pl` and/or the Python package.
3. Run `ruff check .`, `ruff format --check .`, `pytest` and
   `fuzzy-countries validate`.
4. Regenerate `exports/` only if your change affects the model or the data.

## License and citation

Code and documentation are released under the [MIT License](LICENSE). The raw
datasets keep their original providers' terms; see
[`docs/data_dictionary.md`](docs/data_dictionary.md#data-licenses).

If you use this project academically, cite the original thesis and the
repository. A `CITATION.cff` file is included for GitHub's "Cite this
repository" button.

## Acknowledgements

- [Ciao Prolog](https://ciao-lang.org/) and the RFuzzy library.
- The original TFG supervisors and the UPM for the academic context.
- The data providers listed in the data dictionary.
