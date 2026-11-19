"""Tests for the Python reference implementation of the RFuzzy model."""

from __future__ import annotations

import pytest

from fuzzy_countries import FuzzyModel, ModelError, interpolate


def test_model_dimensions(model: FuzzyModel) -> None:
    assert model.summary() == {
        "countries": 49,
        "indicators": 28,
        "functions": 26,
        "rules": 17,
    }
    assert model.validate() == []


def test_interpolation_endpoints_and_midpoint() -> None:
    points = ((0, 0), (10, 1))
    assert interpolate(points, -5) == 0
    assert interpolate(points, 0) == 0
    assert interpolate(points, 5) == 0.5
    assert interpolate(points, 10) == 1
    assert interpolate(points, 50) == 1


def test_interpolation_piecewise() -> None:
    points = ((400, 0), (500, 0.2), (600, 0.4))
    assert interpolate(points, 450) == pytest.approx(0.1)
    assert interpolate(points, 550) == pytest.approx(0.3)


def test_membership_function_metadata(model: FuzzyModel) -> None:
    function = model.functions["high_economic_freedom"]
    assert function.variable == "economic_freedom_index"
    assert function.evaluate(400) == 0
    assert function.evaluate(900) == 1
    assert function.evaluate(650) == pytest.approx(0.5)


def test_rule_components_and_negation(model: FuzzyModel) -> None:
    rule = model.rules["clean_country"]
    assert [component.function for component in rule.components] == [
        "abundant_renewable_energy",
        "critical_co2",
    ]
    assert [component.negated for component in rule.components] == [False, True]


def test_known_rankings(model: FuzzyModel) -> None:
    clean = [country for country, _ in model.ranking("clean_country", top=3)]
    assert clean == ["Iceland", "Norway", "Denmark"]

    developed = [country for country, _ in model.ranking("developed_country", top=1)]
    assert developed == ["Japan"]

    stable = [country for country, _ in model.ranking("economically_stable_country", top=1)]
    assert stable == ["Thailand"]

    healthcare = [country for country, _ in model.ranking("quality_healthcare_country", top=10)]
    assert "Spain" in healthcare


def test_scores_are_fuzzy_values(model: FuzzyModel) -> None:
    for country in model.countries:
        scores = model.evaluate_country(country)
        assert set(scores) == set(model.rules)
        assert all(0.0 <= score <= 1.0 for score in scores.values())


def test_ranking_is_sorted(model: FuzzyModel) -> None:
    ranking = model.ranking("developed_country")
    scores = [score for _, score in ranking]
    assert scores == sorted(scores, reverse=True)
    assert len(ranking) == len(model.countries)


def test_unknown_country_and_rule_raise(model: FuzzyModel) -> None:
    with pytest.raises(ModelError):
        model.evaluate_country("Atlantis")
    with pytest.raises(ModelError):
        model.ranking("not_a_rule")


def test_invalid_prolog_raises() -> None:
    with pytest.raises(ModelError):
        FuzzyModel.from_text("this is not a model")
