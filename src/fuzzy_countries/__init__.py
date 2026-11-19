"""Convenience exports for the :mod:`fuzzy_countries` package."""

from .model import (
    CountryRecord,
    FuzzyModel,
    FuzzyRule,
    MembershipFunction,
    ModelError,
    RuleComponent,
    interpolate,
)
from .variables import (
    EXPECTED_COUNTS,
    RULE_DESCRIPTIONS,
    TYPE_ORDER,
    VARIABLE_BY_NAME,
    VARIABLES,
    Variable,
)

__all__ = [
    "CountryRecord",
    "EXPECTED_COUNTS",
    "FuzzyModel",
    "FuzzyRule",
    "MembershipFunction",
    "ModelError",
    "RULE_DESCRIPTIONS",
    "RuleComponent",
    "TYPE_ORDER",
    "VARIABLE_BY_NAME",
    "VARIABLES",
    "Variable",
    "interpolate",
]

__version__ = "0.2.0"
