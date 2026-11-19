# Data quality report

The model data is **not** perfectly consistent. The Python engine deliberately
uses the values in `code.pl` as-is, because those are the values that produced
the published results. Fixing them silently would change the rankings and make
the thesis irreproducible.

The audit compares each raw value (from `Data/bd_definitiva.csv`) with the
integer stored in `code.pl`:

```bash
fuzzy-countries audit
```

It currently flags **8 rows in 8 variables**:

| Country | Variable | Raw value | `code.pl` value | Expected scaled | Impact |
| --- | --- | ---: | ---: | ---: | --- |
| Canada | `surface_temperature` | -3.7 °C | `370` | `-370` | The sign is lost. `risk_high_temperature` returns ≈0.065 instead of 0, slightly boosting Canada in `attractive_tourism_destination`. |
| Belarus | `cpi` | missing | `12344` | n/a | The model treats CPI as 123.44 while the raw table has no value. This affects `economically_stable_country` (negated CPI). |
| Ecuador | `tax_revenue` | missing | `220` | n/a | The model assumes 22.0% tax revenue; affects `active_civic_participation_country`, `strong_labor_market` and `big_economy`. |
| Algeria | `unemployment` | 11.7% | `117` | `1170` | The model uses 1.17% instead of 11.7%. `economically_stable_country` and `big_economy` overstate Algeria. |
| Algeria | `latitude` | 28.033886 | `28.033886` | `2803388.6` | Only affects the scaled representation. The export uses the raw coordinate, so the map is correct. |
| Algeria | `longitude` | 1.659626 | `1.659626` | `165962.6` | Same as latitude. |
| Algeria | `renewables` | 0.261367% | `261367` | `26136.7` | The model uses 2.61367% instead of 0.261367%. `clean_country` and `environmentally_friendly_country` overstate Algeria. |
| Luxembourg | `median_age` | 40.0 years | `49` | `40` | `aging_population_country` overstates Luxembourg (it appears 4th with 0.856). |

The full machine-readable report is written to
`Data/processed/data_quality.csv` by `fuzzy-countries build-data`, and the
export includes `is_consistent` / `data_quality_issue` columns in
`exports/fact_indicator_value.csv`.

## Other historical artefacts

### Two different integer tables

| File | Format | Status |
| --- | --- | --- |
| `Data/bdd_int.csv` | Prolog facts (`country(...).`) with a `.csv` extension | Unused by the current pipeline. It is not a CSV. |
| `cred/data/bdd_int.csv` | CSV header plus Prolog-formatted rows (quoted country names, trailing `).`) | Used by the legacy credibility pipeline. It is repaired on load. |

The two files disagree in at least one place: `cred/data/bdd_int.csv` stores
`0` for Belarus' CPI, while `code.pl` stores `12344`. The Python model uses
`code.pl`; the legacy pipeline uses `cred/data/bdd_int.csv`. This is one reason
the Python reference implementation and the legacy credibility values are not
interchangeable.

### Duplicate happiness files

`cred/data/happy_1.csv` and `cred/data/happy_2.csv` are byte-identical
(SHA-256 `BA2E8711...D526`). They are kept for provenance; new code should use
`Data/World Happiness Report 2021.csv`.

### Tied ranks in the World Happiness Report

The WHR uses `method="min"` ties. In the 2021 file, ranks 57 and 76 are shared
by two countries each, and the 49-country subset contains both tied pairs
(Argentina/Portugal and Russia/Hong Kong). `rank` is therefore not unique in
`fact_happiness.csv`; use `ladder_score` for ordering and `rank` only for
display.

### Unused model variables

- `latitude` and `longitude` have no membership function.
- `land_area` and `armed_forces_size` have functions (`extensive_surface`,
  `strong_armed_forces_rate`) but no active rule uses them. They are kept
  because they document the original model and may be used by future rules.

## Recomputing the audit

```bash
# Print the table and write a CSV
fuzzy-countries audit --out Data/processed/data_quality.csv

# Rebuild raw, scaled and quality tables
fuzzy-countries build-data --out Data/processed
```

If you decide to correct a value, edit `code.pl` **and** add or update a
regression test in `tests/test_model.py` so the change is intentional. The
current tests assert the published rankings, not the exact score of every
country, so a correction will be visible in the ranking assertions.
