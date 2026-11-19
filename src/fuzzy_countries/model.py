"""Reference Python implementation of the RFuzzy model in ``code.pl``.

The Ciao Prolog program remains the source of truth.  This module reads the
same file, extracts the fuzzy membership functions and rules, and evaluates
them with the same semantics:

* membership functions are piecewise-linear and clamped at their endpoints;
* ``fnot`` is the standard fuzzy negation ``1 - x``;
* every active rule aggregates its components with the arithmetic mean.

Having a small, dependency-free reference implementation makes the project
runnable on any operating system (the original Ciao binary is Linux-only) and
lets the export layer produce analysis-ready tables for Power BI.
"""

from __future__ import annotations

import re
import statistics
from collections.abc import Iterable
from dataclasses import dataclass
from pathlib import Path

from .variables import EXPECTED_COUNTS, TYPE_ORDER


class ModelError(ValueError):
    """Raised when ``code.pl`` cannot be parsed or is inconsistent."""


@dataclass(frozen=True)
class RuleComponent:
    """One antecedent of a fuzzy rule."""

    function: str
    negated: bool = False


@dataclass(frozen=True)
class MembershipFunction:
    """A piecewise-linear membership function."""

    name: str
    variable: str
    points: tuple[tuple[float, float], ...]

    def evaluate(self, value: float) -> float:
        """Return the truth value of ``value`` in this fuzzy set."""
        return interpolate(self.points, float(value))

    @property
    def breakpoints(self) -> tuple[float, ...]:
        return tuple(point[0] for point in self.points)


@dataclass(frozen=True)
class FuzzyRule:
    """A fuzzy rule with a mean aggregation and a minimum credibility."""

    name: str
    components: tuple[RuleComponent, ...]
    credibility: float
    aggregation: str = "mean"


@dataclass(frozen=True)
class CountryRecord:
    """One ``country/30`` fact."""

    number: int
    name: str
    values: dict[str, float]

    def value(self, variable: str) -> float:
        try:
            return self.values[variable]
        except KeyError as exc:  # pragma: no cover - defensive
            raise ModelError(f"{self.name!r} has no value for {variable!r}") from exc


_FACT_RE = re.compile(r"^country\((.*)\)\.\s*$", re.MULTILINE)
_TOKEN_RE = re.compile(r"'([^']*)'|(-?\d+(?:\.\d+)?)")
_DATABASE_RE = re.compile(
    r"define_database\(\s*country/30\s*,\s*\[(.*?)\]\s*\)\.",
    re.DOTALL,
)
_TYPE_RE = re.compile(r"\(\s*(\w+)\s*,\s*rfuzzy_\w+_type\s*\)")
_FUNCTION_RE = re.compile(r"^(\w+)\(country\)\s*:~\s*function\((\w+)\(country\),\s*\[(.*)\]\)\.$")
_POINT_RE = re.compile(r"\(\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\)")
_RULE_RE = re.compile(
    r"^(\w+)\(country\)\s*:~\s*rule\((\w+),\s*(.*)\)\s*"
    r"with_credibility\s*\(min,\s*([\d.]+)\)\.$"
)
_COMPONENT_RE = re.compile(r"(fnot)?[\(\s]*(\w+)\(country\)")


def interpolate(points: Iterable[tuple[float, float]], value: float) -> float:
    """Piecewise-linear interpolation clamped to the first/last point."""
    ordered = sorted((float(x), float(y)) for x, y in points)
    if not ordered:
        raise ModelError("A membership function needs at least one point")
    if value <= ordered[0][0]:
        return ordered[0][1]
    if value >= ordered[-1][0]:
        return ordered[-1][1]
    for (x0, y0), (x1, y1) in zip(ordered, ordered[1:], strict=False):
        if x0 <= value <= x1:
            if x1 == x0:
                return y1
            return y0 + (y1 - y0) * (value - x0) / (x1 - x0)
    return ordered[-1][1]


class FuzzyModel:
    """Parsed and evaluable version of the RFuzzy model."""

    def __init__(
        self,
        functions: dict[str, MembershipFunction],
        rules: dict[str, FuzzyRule],
        countries: dict[str, CountryRecord],
        *,
        source: str | Path | None = None,
    ) -> None:
        self.functions = dict(functions)
        self.rules = dict(rules)
        self.countries = dict(countries)
        self.source = Path(source) if source is not None else None
        self._cache: dict[str, dict[str, float]] | None = None

    # ------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------
    @classmethod
    def from_file(cls, path: str | Path = "code.pl") -> FuzzyModel:
        path = Path(path)
        text = path.read_text(encoding="utf-8", errors="replace")
        return cls.from_text(text, source=path)

    @classmethod
    def from_text(cls, text: str, *, source: str | Path | None = None) -> FuzzyModel:
        types = _parse_types(text)
        functions = _parse_functions(text, types)
        rules = _parse_rules(text)
        countries = _parse_countries(text, types)

        model = cls(functions, rules, countries, source=source)
        model.assert_valid()
        return model

    # ------------------------------------------------------------------
    # Evaluation
    # ------------------------------------------------------------------
    def function_values(self, country: str) -> dict[str, float]:
        """Truth value of every membership function for one country."""
        try:
            record = self.countries[country]
        except KeyError as exc:
            raise ModelError(f"Unknown country: {country!r}") from exc

        return {
            name: function.evaluate(record.value(function.variable))
            for name, function in self.functions.items()
        }

    def evaluate_country(self, country: str) -> dict[str, float]:
        """Score of every active rule for one country."""
        function_values = self.function_values(country)
        scores: dict[str, float] = {}
        for name, rule in self.rules.items():
            components = [
                1.0 - function_values[component.function]
                if component.negated
                else function_values[component.function]
                for component in rule.components
            ]
            scores[name] = statistics.fmean(components) if components else 0.0
        return scores

    def evaluate_all(self) -> dict[str, dict[str, float]]:
        """Scores for every country and rule (cached)."""
        if self._cache is None:
            self._cache = {country: self.evaluate_country(country) for country in self.countries}
        return self._cache

    def ranking(self, rule: str, top: int | None = None) -> list[tuple[str, float]]:
        """Countries sorted by their score for ``rule`` (descending)."""
        if rule not in self.rules:
            raise ModelError(f"Unknown rule: {rule!r}")
        scores = {country: values[rule] for country, values in self.evaluate_all().items()}
        ranked = sorted(scores.items(), key=lambda item: (-item[1], item[0]))
        return ranked[:top] if top is not None else ranked

    # ------------------------------------------------------------------
    # Validation
    # ------------------------------------------------------------------
    def validate(self) -> list[str]:
        """Return a list of consistency problems (empty means valid)."""
        problems: list[str] = []
        if len(self.countries) != EXPECTED_COUNTS["countries"]:
            problems.append(
                f"Expected {EXPECTED_COUNTS['countries']} countries, found {len(self.countries)}"
            )
        if len(self.functions) != EXPECTED_COUNTS["functions"]:
            problems.append(
                f"Expected {EXPECTED_COUNTS['functions']} membership functions, "
                f"found {len(self.functions)}"
            )
        if len(self.rules) != EXPECTED_COUNTS["rules"]:
            problems.append(
                f"Expected {EXPECTED_COUNTS['rules']} active rules, found {len(self.rules)}"
            )

        for name, function in self.functions.items():
            xs = [x for x, _ in function.points]
            if len(xs) < 2:
                problems.append(f"{name}: fewer than two points")
            if len(set(xs)) != len(xs):
                problems.append(f"{name}: duplicated x coordinates")
            if any(not 0.0 <= y <= 1.0 for _, y in function.points):
                problems.append(f"{name}: truth values outside [0, 1]")

        for name, rule in self.rules.items():
            if not rule.components:
                problems.append(f"{name}: rule has no components")
            for component in rule.components:
                if component.function not in self.functions:
                    problems.append(f"{name}: unknown function {component.function!r}")
            if rule.aggregation != "mean":
                problems.append(f"{name}: unsupported aggregation {rule.aggregation!r}")

        for country in self.countries.values():
            missing = set(TYPE_ORDER[2:]) - set(country.values)
            if missing:
                problems.append(f"{country.name}: missing variables {sorted(missing)}")

        if not problems:
            for country in self.countries:
                for rule, score in self.evaluate_country(country).items():
                    if not -1e-9 <= score <= 1.0 + 1e-9:
                        problems.append(f"{country}/{rule}: score outside [0, 1]")
        return problems

    def assert_valid(self) -> None:
        problems = self.validate()
        if problems:
            raise ModelError("Invalid model:\n- " + "\n- ".join(problems))

    # ------------------------------------------------------------------
    # Introspection helpers
    # ------------------------------------------------------------------
    @property
    def variables(self) -> tuple[str, ...]:
        return tuple(sorted({function.variable for function in self.functions.values()}))

    def summary(self) -> dict[str, int]:
        return {
            "countries": len(self.countries),
            "indicators": len(TYPE_ORDER) - 2,
            "functions": len(self.functions),
            "rules": len(self.rules),
        }

    def __repr__(self) -> str:  # pragma: no cover - cosmetic
        summary = self.summary()
        return (
            f"FuzzyModel(countries={summary['countries']}, "
            f"functions={summary['functions']}, rules={summary['rules']})"
        )


# ----------------------------------------------------------------------
# Parsers
# ----------------------------------------------------------------------
def _parse_types(text: str) -> tuple[str, ...]:
    match = _DATABASE_RE.search(text)
    if not match:
        raise ModelError("Could not find the define_database(country/30, ...) block")
    types = tuple(_TYPE_RE.findall(match.group(1)))
    if len(types) != 30:
        raise ModelError(f"Expected 30 columns in country/30, found {len(types)}")
    if types != TYPE_ORDER:
        raise ModelError(
            "The country/30 type declaration does not match src/fuzzy_countries/variables.py"
        )
    return types


def _parse_functions(text: str, types: tuple[str, ...]) -> dict[str, MembershipFunction]:
    functions: dict[str, MembershipFunction] = {}
    for line in _active_lines(text):
        match = _FUNCTION_RE.match(line)
        if not match:
            continue
        name, variable, raw_points = match.groups()
        if variable not in types:
            raise ModelError(f"{name}: variable {variable!r} is not in country/30")
        points = tuple((float(x), float(y)) for x, y in _POINT_RE.findall(raw_points))
        if not points:
            raise ModelError(f"{name}: no breakpoints found")
        if name in functions:
            raise ModelError(f"Duplicated membership function: {name}")
        functions[name] = MembershipFunction(name, variable, points)
    if not functions:
        raise ModelError("No membership functions found")
    return functions


def _parse_rules(text: str) -> dict[str, FuzzyRule]:
    rules: dict[str, FuzzyRule] = {}
    for line in _active_lines(text):
        match = _RULE_RE.match(line)
        if not match:
            continue
        name, aggregation, body, credibility = match.groups()
        components = tuple(
            RuleComponent(function=function, negated=bool(negated))
            for negated, function in _COMPONENT_RE.findall(body)
        )
        if name in rules:
            raise ModelError(f"Duplicated rule: {name}")
        rules[name] = FuzzyRule(
            name=name,
            components=components,
            credibility=float(credibility),
            aggregation=aggregation,
        )
    if not rules:
        raise ModelError("No rules found")
    return rules


def _parse_countries(text: str, types: tuple[str, ...]) -> dict[str, CountryRecord]:
    countries: dict[str, CountryRecord] = {}
    for body in _FACT_RE.findall(text):
        tokens = [
            name if name else (float(number) if "." in number else int(number))
            for name, number in _TOKEN_RE.findall(body)
        ]
        if len(tokens) != len(types):
            raise ModelError(
                f"Country fact has {len(tokens)} fields, expected {len(types)}: {tokens[:2]}..."
            )
        number, name, *values = tokens
        if not isinstance(name, str):
            raise ModelError(f"Country name is not a string: {name!r}")
        if name in countries:
            raise ModelError(f"Duplicated country: {name}")
        countries[name] = CountryRecord(
            number=int(number),
            name=name,
            values={
                variable: float(value) for variable, value in zip(types[2:], values, strict=True)
            },
        )
    if not countries:
        raise ModelError("No country facts found")
    return countries


def _active_lines(text: str) -> Iterable[str]:
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if line and not line.startswith("%"):
            yield line
