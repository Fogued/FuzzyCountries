# Data dictionary

The project stores the same information in three places:

| Representation | File | Role |
| --- | --- | --- |
| Model facts | `code.pl` (`country/30`) | **Canonical** input used by the fuzzy model. Integer values with a fixed number of decimals. |
| Raw table | `Data/bd_definitiva.csv` | Human-readable values, including `%` and `$` formatting. Used for labels, units and the Power BI export. |
| Legacy integer table | `cred/data/bdd_int.csv` | Historical export used by the credibility pipeline. It contains a few formatting artefacts and is not the source of truth. |

The Python package reads `code.pl` directly, so the model evaluation does not
depend on the legacy CSV. `Data/bd_definitiva.csv` is only used to recover the
raw values and units.

## Indicators

`Scale` means: `value in code.pl = round(raw value × 10^scale)`. For example,
an economic freedom index of `4.82` is stored as `482` (`scale = 2`).

| Variable | Label | Unit | Scale | Source | Raw column |
| --- | --- | --- | ---: | --- | --- |
| `economic_freedom_index` | Economic freedom index | index (0-10) | `1e2` | Fraser Institute, *Economic Freedom of the World* (2021) | `Libertad Economica` |
| `surface_temperature` | Mean surface temperature | °C | `1e2` | Kaggle, mean temperature for countries by year (2021) | `Temperatura media superficie (2021)` |
| `suicides` | Suicide rate | deaths per 100,000 people | `1e5` | WHO Global Health Observatory | `Tasa de suicidios (/100.000hab)` |
| `people_percive_corruption` | Perceived corruption | index | `1e3` | World Happiness Report 2021 | `Poblacion percibe corrupcion` |
| `population_density` | Population density | people per km² | `1e0` | World Data 2023 (Kaggle) | `Density (P/Km2)` |
| `agricultural_land` | Agricultural land | % of land area | `1e1` | World Data 2023 (Kaggle) | `Agricultural Land( %)` |
| `land_area` | Land area | km² | `1e0` | World Data 2023 (Kaggle) | `Land Area(Km2)` |
| `armed_forces_size` | Armed forces size | people | `1e0` | World Data 2023 (Kaggle) | `Armed Forces size` |
| `birth` | Birth rate | births per 1,000 people | `1e2` | World Data 2023 (Kaggle) | `Birth Rate` |
| `co2_emissions` | CO₂ emissions | tonnes | `1e0` | World Data 2023 (Kaggle) | `Co2-Emissions` |
| `cpi` | Consumer price index | index | `1e2` | World Data 2023 (Kaggle) | `CPI` |
| `fertility` | Fertility rate | births per woman | `1e2` | World Data 2023 (Kaggle) | `Fertility Rate` |
| `forested_area` | Forested area | % of land area | `1e2` | World Data 2023 (Kaggle) | `Forested Area (%)` |
| `gdp` | Gross domestic product | current US$ | `1e0` | World Data 2023 (Kaggle) | `GDP` |
| `gross_primary_education_enrollment` | Gross primary education enrollment | % | `1e1` | World Data 2023 (Kaggle) | `Gross primary education enrollment (%)` |
| `gross_tertiary_education_enrollment` | Gross tertiary education enrollment | % | `1e1` | World Data 2023 (Kaggle) | `Gross tertiary education enrollment (%)` |
| `infant_mortality` | Infant mortality | deaths per 1,000 live births | `1e1` | World Data 2023 (Kaggle) | `Infant mortality` |
| `life_expectancy` | Life expectancy | years | `1e1` | World Data 2023 (Kaggle) | `Life expectancy` |
| `population` | Population | people | `1e0` | World Data 2023 (Kaggle) | `Population` |
| `labor_force` | Labor force participation | % | `1e1` | World Data 2023 (Kaggle) | `Population: Labor force participation (%)` |
| `tax_revenue` | Tax revenue | % of GDP | `1e1` | World Data 2023 (Kaggle) | `Tax revenue (%)` |
| `unemployment` | Unemployment rate | % | `1e2` | World Data 2023 (Kaggle) | `Unemployment rate` |
| `urban_population` | Urban population | people | `1e0` | World Data 2023 (Kaggle) | `Urban_population` |
| `latitude` | Latitude | degrees | `1e5` | World Data 2023 (Kaggle) | `Latitude` |
| `longitude` | Longitude | degrees | `1e5` | World Data 2023 (Kaggle) | `Longitude` |
| `renewables` | Renewable energy share | % of equivalent primary energy | `1e5` | Kaggle, renewable energy world-wide 1965-2022 | `Renewables (% equivalent primary energy)` |
| `minimum_wage` | Minimum wage | annual US$ | `1e0` | Kaggle, minimum wage by country | `Minimum wage` |
| `median_age` | Median age | years | `1e0` | Kaggle, countryinfo | `medianage` |

## Derived tables

`fuzzy-countries build-data` writes:

| File | Contents |
| --- | --- |
| `Data/processed/countries_raw.csv` | 49 rows × 30 columns. Cleaned raw values (percentages as numbers). |
| `Data/processed/countries_scaled.csv` | 49 rows × 30 columns. Exact integer values from `code.pl`. |
| `Data/processed/data_quality.csv` | Every raw/scaled mismatch, with the expected value and the difference. |
| `Data/processed/data_quality_summary.csv` | Number of flagged rows per variable. |

`fuzzy-countries export` writes the star schema described in
[powerbi.md](powerbi.md). The most important table is
`fact_indicator_value.csv`, which contains:

| Column | Meaning |
| --- | --- |
| `country_id`, `country` | Country key and display name. |
| `indicator_id` | Variable name, e.g. `life_expectancy`. |
| `raw_value` | Value in the original units (from `bd_definitiva.csv`). |
| `scaled_value` | Integer value used by `code.pl`. |
| `expected_scaled` | `raw_value × 10^scale`; empty when the raw value is missing. |
| `difference` | `scaled_value - expected_scaled`; empty when the raw value is missing. |
| `truth_value` | Membership degree in `[0, 1]` for the indicator's fuzzy set. Empty for latitude/longitude. |
| `is_consistent` | `False` when the raw and scaled values do not agree. |
| `data_quality_issue` | `OK`, `missing raw value` or `scaled value does not match raw value`. |

## Country names and codes

The 49 country names in `code.pl` are matched by exact name against:

- `Data/covid19countryinfo(4).csv` — ISO-3166 alpha-2/alpha-3 codes.
- `Data/World Happiness Report 2021.csv` — happiness score and regional indicator.
- `Data/renewable-share-energy(2).csv`, `Data/temperaturas anuales.csv`,
  `Data/suicidios.csv` — yearly series.

All 49 names match in all five sources. `dim_country.csv` exposes the ISO
codes and the WHR region so Power BI can use a map and a region slicer without
extra cleaning.

## Missing values and zeros

- A `0` in `minimum_wage` means that the country has no statutory minimum wage
  (for example, Sweden and Norway), not that the wage is literally zero. The
  model treats it as "low minimum wage", which is a known limitation.
- A `0` in `armed_forces_size` (Iceland) means no standing army.
- `Belarus` has no CPI in the raw table and `Ecuador` has no tax revenue value;
  see [data_quality.md](data_quality.md).

## Data licenses

The MIT license in this repository applies to the source code and the
documentation, not to the third-party datasets. Check the original providers'
terms before redistributing the raw CSVs.
