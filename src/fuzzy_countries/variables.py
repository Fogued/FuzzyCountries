"""Static metadata for the socioeconomic model.

The model itself lives in ``code.pl`` (Ciao Prolog + RFuzzy).  This module only
describes the variables so the Python tooling can parse, audit and export the
same data without duplicating the logic.

The ``scale_exponent`` field is the power of ten that was used to turn the raw
indicator into the integer values stored in ``code.pl``.  The original comment
in ``code.pl`` lists a few exponents that do not match the data; the values
below are the ones that reproduce the model (see ``docs/data_quality.md``).
"""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Variable:
    """Description of one indicator used by the fuzzy model."""

    name: str
    label: str
    unit: str
    scale_exponent: int
    source: str
    category: str
    raw_column: str
    description: str = ""


VARIABLES: tuple[Variable, ...] = (
    Variable(
        name="economic_freedom_index",
        label="Economic freedom index",
        unit="index (0-10)",
        scale_exponent=2,
        source="Fraser Institute, Economic Freedom of the World (2021)",
        category="Governance",
        raw_column="Libertad Economica",
        description="Summary index of economic freedom.",
    ),
    Variable(
        name="surface_temperature",
        label="Mean surface temperature",
        unit="°C",
        scale_exponent=2,
        source="Kaggle, mean temperature for countries by year (2021)",
        category="Environment",
        raw_column="Temperatura media superficie (2021)",
        description="Annual mean surface temperature for 2021.",
    ),
    Variable(
        name="suicides",
        label="Suicide rate",
        unit="deaths per 100,000 people",
        scale_exponent=5,
        source="WHO Global Health Observatory",
        category="Health",
        raw_column="Tasa de suicidios (/100.000hab)",
        description="Crude suicide rate per 100,000 inhabitants (2006 snapshot).",
    ),
    Variable(
        name="people_percive_corruption",
        label="Perceived corruption",
        unit="index",
        scale_exponent=3,
        source="World Happiness Report 2021",
        category="Governance",
        raw_column="Poblacion percibe corrupcion",
        description="Perceptions of corruption component of the WHR.",
    ),
    Variable(
        name="population_density",
        label="Population density",
        unit="people per km²",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Demography",
        raw_column="Density (P/Km2)",
    ),
    Variable(
        name="agricultural_land",
        label="Agricultural land",
        unit="% of land area",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Environment",
        raw_column="Agricultural Land( %)",
    ),
    Variable(
        name="land_area",
        label="Land area",
        unit="km²",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Geography",
        raw_column="Land Area(Km2)",
    ),
    Variable(
        name="armed_forces_size",
        label="Armed forces size",
        unit="people",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Defence",
        raw_column="Armed Forces size",
    ),
    Variable(
        name="birth",
        label="Birth rate",
        unit="births per 1,000 people",
        scale_exponent=2,
        source="World Data 2023 (Kaggle)",
        category="Demography",
        raw_column="Birth Rate",
    ),
    Variable(
        name="co2_emissions",
        label="CO₂ emissions",
        unit="tonnes",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Environment",
        raw_column="Co2-Emissions",
    ),
    Variable(
        name="cpi",
        label="Consumer price index",
        unit="index",
        scale_exponent=2,
        source="World Data 2023 (Kaggle)",
        category="Economy",
        raw_column="CPI",
    ),
    Variable(
        name="fertility",
        label="Fertility rate",
        unit="births per woman",
        scale_exponent=2,
        source="World Data 2023 (Kaggle)",
        category="Demography",
        raw_column="Fertility Rate",
    ),
    Variable(
        name="forested_area",
        label="Forested area",
        unit="% of land area",
        scale_exponent=2,
        source="World Data 2023 (Kaggle)",
        category="Environment",
        raw_column="Forested Area (%)",
    ),
    Variable(
        name="gdp",
        label="Gross domestic product",
        unit="current US$",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Economy",
        raw_column="GDP",
    ),
    Variable(
        name="gross_primary_education_enrollment",
        label="Gross primary education enrollment",
        unit="%",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Education",
        raw_column="Gross primary education enrollment (%)",
    ),
    Variable(
        name="gross_tertiary_education_enrollment",
        label="Gross tertiary education enrollment",
        unit="%",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Education",
        raw_column="Gross tertiary education enrollment (%)",
    ),
    Variable(
        name="infant_mortality",
        label="Infant mortality",
        unit="deaths per 1,000 live births",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Health",
        raw_column="Infant mortality",
    ),
    Variable(
        name="life_expectancy",
        label="Life expectancy",
        unit="years",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Health",
        raw_column="Life expectancy",
    ),
    Variable(
        name="population",
        label="Population",
        unit="people",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Demography",
        raw_column="Population",
    ),
    Variable(
        name="labor_force",
        label="Labor force participation",
        unit="%",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Labour",
        raw_column="Population: Labor force participation (%)",
    ),
    Variable(
        name="tax_revenue",
        label="Tax revenue",
        unit="% of GDP",
        scale_exponent=1,
        source="World Data 2023 (Kaggle)",
        category="Economy",
        raw_column="Tax revenue (%)",
    ),
    Variable(
        name="unemployment",
        label="Unemployment rate",
        unit="%",
        scale_exponent=2,
        source="World Data 2023 (Kaggle)",
        category="Labour",
        raw_column="Unemployment rate",
    ),
    Variable(
        name="urban_population",
        label="Urban population",
        unit="people",
        scale_exponent=0,
        source="World Data 2023 (Kaggle)",
        category="Demography",
        raw_column="Urban_population",
    ),
    Variable(
        name="latitude",
        label="Latitude",
        unit="degrees",
        scale_exponent=5,
        source="World Data 2023 (Kaggle)",
        category="Geography",
        raw_column="Latitude",
    ),
    Variable(
        name="longitude",
        label="Longitude",
        unit="degrees",
        scale_exponent=5,
        source="World Data 2023 (Kaggle)",
        category="Geography",
        raw_column="Longitude",
    ),
    Variable(
        name="renewables",
        label="Renewable energy share",
        unit="% of equivalent primary energy",
        scale_exponent=5,
        source="Kaggle, renewable energy world-wide 1965-2022",
        category="Environment",
        raw_column="Renewables (% equivalent primary energy)",
        description="Share of primary energy from renewable sources (2021 snapshot).",
    ),
    Variable(
        name="minimum_wage",
        label="Minimum wage",
        unit="annual US$",
        scale_exponent=0,
        source="Kaggle, minimum wage by country",
        category="Labour",
        raw_column="Minimum wage",
        description="Annual nominal minimum wage; countries without a statutory minimum are stored as 0.",
    ),
    Variable(
        name="median_age",
        label="Median age",
        unit="years",
        scale_exponent=0,
        source="Kaggle, countryinfo",
        category="Demography",
        raw_column="medianage",
    ),
)

VARIABLE_BY_NAME: dict[str, Variable] = {variable.name: variable for variable in VARIABLES}

# Order used by the ``country/30`` predicate in ``code.pl``.
TYPE_ORDER: tuple[str, ...] = ("country_number", "country_name") + tuple(
    variable.name for variable in VARIABLES
)

# Regression guard for the published model.  Update these values together with
# the model and the tests if you intentionally add/remove a country or a rule.
EXPECTED_COUNTS = {
    "countries": 49,
    "indicators": len(VARIABLES),
    "functions": 26,
    "rules": 17,
}

# Raw CSV column name -> model variable name.
RAW_COLUMNS: dict[str, str] = {variable.raw_column: variable.name for variable in VARIABLES}


RULE_DESCRIPTIONS: dict[str, str] = {
    "clean_country": "High renewable energy share and low CO₂ emissions.",
    "environmentally_friendly_country": (
        "Renewables, low CO₂, forest cover and agricultural land."
    ),
    "developed_country": ("GDP, life expectancy, low infant mortality and economic freedom."),
    "political_stable_country": "Economic freedom and low perceived corruption.",
    "strong_education_system": ("Primary and tertiary education enrollment with low unemployment."),
    "low_population_growth_country": ("Low birth rate, low fertility and low infant mortality."),
    "urbanized_country": ("Large urban population, high density and low agricultural/forest land."),
    "economically_stable_country": "Low inflation (CPI) and low unemployment.",
    "high_income_country": "High GDP and high minimum wage.",
    "aging_population_country": ("High median age, low birth rate and high life expectancy."),
    "quality_healthcare_country": "Low infant mortality and high life expectancy.",
    "attractive_tourism_destination": (
        "Warm climate, forests, life expectancy, low infant mortality, GDP and urban population."
    ),
    "active_civic_participation_country": (
        "High tax revenue, economic freedom and low perceived corruption."
    ),
    "high_wellbeing_country": (
        "Economic freedom, life expectancy, low corruption, low suicide rate, "
        "education, low infant mortality and GDP."
    ),
    "good_education_and_future_country": (
        "Primary and tertiary education, low infant mortality and GDP."
    ),
    "strong_labor_market": ("Active workers, low unemployment and high tax revenue."),
    "big_economy": ("Large population, low unemployment, high tax revenue and high GDP."),
}
