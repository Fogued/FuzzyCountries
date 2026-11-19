# The fuzzy model

The model is a Mamdani-style fuzzy rule base written in Ciao Prolog with
[RFuzzy](https://github.com/ciao-lang/rfuzzy). Each country is a fact with 28
numeric indicators; each indicator is mapped to one or more fuzzy sets by a
piecewise-linear membership function; each rule combines those sets with the
arithmetic mean. The result of a rule is a truth value in `[0, 1]`.

`code.pl` is the source of truth. The Python module
`fuzzy_countries.model` parses the same file and implements the same semantics,
so the project can be analysed on Windows/macOS/Linux without the Ciao runtime.

## Semantics

```prolog
% One membership function
high_economic_freedom(country) :~
    function(economic_freedom_index(country),
             [(400, 0), (500, 0.2), (600, 0.4), (700, 0.6), (800, 0.8), (900, 1)]).

% One rule
clean_country(country) :~
    rule(mean, (abundant_renewable_energy(country),
                fnot(critical_co2(country))))
    with_credibility (min, 1).
```

For a country value `x`:

1. **Membership**: interpolate linearly between the two surrounding
   breakpoints. Values below the first point return the first truth value;
   values above the last point return the last truth value. This is the
   standard RFuzzy piecewise-linear behaviour.
2. **Negation**: `fnot(P)` evaluates to `1 - P`.
3. **Aggregation**: `rule(mean, (...))` evaluates to the arithmetic mean of its
   components. All components have the same weight.
4. **Credibility**: `with_credibility (min, 1)` is rule metadata. It does not
   change the truth value returned by the reference implementation. The
   credibility of each membership function (`1 - MAE` against the normalised
   real indicator) is computed by the legacy pipeline and exported separately.

The breakpoints are expressed in the **scaled integer units** used by
`code.pl`, not in raw units. See the scale column in
[data_dictionary.md](data_dictionary.md). For example, `life_expectancy` is
stored as `767` for `76.7` years, so the `long_life_expectancy` breakpoint
`750` means `75.0` years.

## Membership functions

There are 26 active functions. `land_area` and `armed_forces_size` have
functions but no active rule uses them; `latitude` and `longitude` have no
function at all.

| Function | Variable | Breakpoints `(x, truth)` |
| --- | --- | --- |
| `abundant_renewable_energy` | `renewables` | `(0, 0), (100000, 0.1), (300000, 0.2), (1000000, 0.4), (1800000, 0.6), (3500000, 0.8), (8500000, 0.9), (10000000, 1)` |
| `alarming_suicide_rate` | `suicides` | `(200000, 0), (300000, 0.1), (400000, 0.2), (500000, 0.2), (6000000, 1)` |
| `big_population_size` | `population` | `(0, 0), (10000000, 0.2), (20000000, 0.4), (30000000, 0.5), (40000000, 0.55), (50000000, 0.7), (80000000, 0.9), (220000000, 1), (280000000, 1)` |
| `critical_co2` | `co2_emissions` | `(0, 0), (2000, 0.1), (50000, 0.3), (100000, 0.45), (200000, 0.6), (300000, 0.8), (1300000, 1)` |
| `dangerous_population_density` | `population_density` | `(10, 0), (30, 0.2), (80, 0.4), (150, 0.6), (200, 0.8), (600, 1)` |
| `extensive_surface` | `land_area` | `(50000, 0), (1000000, 0.7), (9000000, 1)` |
| `high_birth_rate` | `birth` | `(700, 0.2), (3200, 1)` |
| `high_corruption_concern` | `people_percive_corruption` | `(0, 0), (200, 0.1), (400, 0.25), (600, 0.35), (900, 0.8), (1200, 1)` |
| `high_cpi_rate` | `cpi` | `(2500, 0.1), (5000, 0.2), (7500, 0.3), (10000, 0.4), (12500, 0.6), (15000, 0.8), (25000, 0.95), (50000, 1)` |
| `high_economic_freedom` | `economic_freedom_index` | `(400, 0), (500, 0.2), (600, 0.4), (700, 0.6), (800, 0.8), (900, 1)` |
| `high_education_primary` | `gross_primary_education_enrollment` | `(0, 0), (700, 0.1), (800, 0.2), (900, 0.4), (950, 0.6), (1000, 0.8), (1800, 1)` |
| `high_education_tertiary` | `gross_tertiary_education_enrollment` | `(0, 0), (100, 0.15), (200, 0.2), (300, 0.4), (400, 0.5), (500, 0.6), (600, 0.7), (900, 0.9), (1000, 1), (2000, 1)` |
| `high_fertility_rate` | `fertility` | `(50, 0), (100, 0.2), (150, 0.4), (200, 0.5), (250, 0.7), (300, 0.8), (600, 1)` |
| `high_infant_mortality_rate` | `infant_mortality` | `(0, 0), (20, 0.1), (50, 0.2), (100, 0.4), (150, 0.6), (200, 0.8), (250, 0.85), (600, 1)` |
| `high_median_age` | `median_age` | `(0, 0), (20, 0.1), (25, 0.2), (30, 0.4), (35, 0.6), (40, 0.8), (45, 0.9), (50, 1)` |
| `high_min_wage` | `minimum_wage` | `(0, 0), (1000, 0.2), (5000, 0.3), (10000, 0.5), (20000, 0.7), (30000, 0.9), (40000, 1)` |
| `high_tax_revenue_percentage` | `tax_revenue` | `(0, 0), (80, 0.25), (150, 0.4), (200, 0.6), (250, 0.65), (300, 0.8), (500, 1)` |
| `huge_agricultural_land_percentage` | `agricultural_land` | `(50, 0), (800, 1)` |
| `large_urban_population` | `urban_population` | `(0, 0), (5000000, 0.1), (10000000, 0.4), (40000000, 0.6), (60000000, 0.8), (120000000, 0.9), (200000000, 1)` |
| `long_life_expectancy` | `life_expectancy` | `(350, 0), (400, 0.2), (550, 0.4), (600, 0.6), (750, 0.8), (900, 1)` |
| `numerous_active_workers` | `labor_force` | `(400, 0), (450, 0.2), (550, 0.4), (650, 0.6), (750, 0.8), (800, 1)` |
| `risk_high_temperature` | `surface_temperature` | `(200, 0), (2800, 1)` |
| `significant_population_unemployed` | `unemployment` | `(0, 0), (300, 0.2), (500, 0.4), (700, 0.5), (1000, 0.8), (3000, 1)` |
| `strong_armed_forces_rate` | `armed_forces_size` | `(1000, 0), (50000, 0.4), (600000, 0.7), (1500000, 1)` |
| `vast_forested_area_percentage` | `forested_area` | `(0, 0), (1100, 0.2), (2200, 0.4), (3300, 0.5), (4400, 0.8), (6000, 0.8), (7000, 0.9), (7310, 0.95)` |
| `wealthy_gdp_per_capita` | `gdp` | `(10000000000, 0.1), (100000000000, 0.3), (600000000000, 0.4), (800000000000, 0.6), (1500000000000, 0.7), (1750000000000, 0.8), (2750000000000, 0.9), (4500000000000, 0.95), (6000000000000, 0.99)` |

## Rules

There are 17 active rules. `NOT` means `fnot`.

| Rule | Components | Credibility |
| --- | --- | ---: |
| `active_civic_participation_country` | `high_tax_revenue_percentage`, `high_economic_freedom`, NOT `high_corruption_concern` | 1 |
| `aging_population_country` | `high_median_age`, NOT `high_birth_rate`, `long_life_expectancy` | 1 |
| `attractive_tourism_destination` | `risk_high_temperature`, `vast_forested_area_percentage`, `long_life_expectancy`, NOT `high_infant_mortality_rate`, `wealthy_gdp_per_capita`, `large_urban_population` | 1 |
| `big_economy` | `big_population_size`, NOT `significant_population_unemployed`, `high_tax_revenue_percentage`, `wealthy_gdp_per_capita` | 1 |
| `clean_country` | `abundant_renewable_energy`, NOT `critical_co2` | 1 |
| `developed_country` | `wealthy_gdp_per_capita`, `long_life_expectancy`, NOT `high_infant_mortality_rate`, `high_economic_freedom` | 1 |
| `economically_stable_country` | NOT `high_cpi_rate`, NOT `significant_population_unemployed` | 1 |
| `environmentally_friendly_country` | `abundant_renewable_energy`, `critical_co2`, `vast_forested_area_percentage`, `huge_agricultural_land_percentage` | 1 |
| `good_education_and_future_country` | `high_education_primary`, `high_education_tertiary`, NOT `high_infant_mortality_rate`, `wealthy_gdp_per_capita` | 1 |
| `high_income_country` | `wealthy_gdp_per_capita`, `high_min_wage` | 1 |
| `high_wellbeing_country` | `high_economic_freedom`, `long_life_expectancy`, NOT `high_corruption_concern`, NOT `alarming_suicide_rate`, `high_education_primary`, NOT `high_infant_mortality_rate`, `wealthy_gdp_per_capita` | 1 |
| `low_population_growth_country` | NOT `high_birth_rate`, NOT `high_fertility_rate`, `high_infant_mortality_rate` | 1 |
| `political_stable_country` | `high_economic_freedom`, NOT `high_corruption_concern` | 1 |
| `quality_healthcare_country` | NOT `high_infant_mortality_rate`, `long_life_expectancy` | 1 |
| `strong_education_system` | `high_education_primary`, `high_education_tertiary`, NOT `significant_population_unemployed` | 1 |
| `strong_labor_market` | `numerous_active_workers`, NOT `significant_population_unemployed`, `high_tax_revenue_percentage` | 1 |
| `urbanized_country` | `large_urban_population`, NOT `huge_agricultural_land_percentage`, `dangerous_population_density`, NOT `vast_forested_area_percentage` | 1 |

## Worked example

For Japan (`developed_country`):

| Component | Japan value | Membership | Contribution |
| --- | ---: | ---: | ---: |
| `wealthy_gdp_per_capita` | GDP ≈ 5.08 × 10¹² US$ | ≈ 0.966 | 0.966 |
| `long_life_expectancy` | 84.2 years (`842`) | ≈ 0.923 | 0.923 |
| NOT `high_infant_mortality_rate` | 1.8 per 1,000 (`18`) | `1 - 0.09` | 0.910 |
| `high_economic_freedom` | 7.79 (`779`) | 0.758 | 0.758 |
| **Rule score** | | | **0.889** |

The point is that the rule is a transparent, auditable average: every
component and every breakpoint can be traced back to `code.pl` and to the
indicator metadata in [data_dictionary.md](data_dictionary.md).

## Adding or changing a rule

1. Edit `code.pl`. Keep the `define_database(country/30, ...)` order unchanged;
   the Python parser checks it against `src/fuzzy_countries/variables.py`.
2. Run `fuzzy-countries validate` and `pytest`.
3. Run `fuzzy-countries rank <rule>` to sanity-check the ranking.
4. Regenerate the export with `fuzzy-countries export`.

If you add a variable, update `VARIABLES` in
`src/fuzzy_countries/variables.py` (name, unit, scale, source and raw column)
and the `country/30` arity in both files. The test suite will fail if the
order or the number of columns diverges.

## Why a Python reference implementation?

The original Ciao binary is a Linux ELF executable and depends on RFuzzy. That
makes the repository hard to run on Windows and hard to use from Power BI. The
Python implementation:

- parses the exact `country/30` facts, so there is no data duplication;
- reproduces the published rankings used as regression tests
  (`clean_country` → Iceland, Norway, Denmark; `developed_country` → Japan;
  `economically_stable_country` → Thailand);
- exposes truth values, ranks and membership degrees as plain CSV files.

It is a **reference implementation**, not a replacement for the academic model:
`code.pl` remains the specification and the Ciao pipeline remains the original
execution path.
