"""Tests for the legacy credibility algorithms."""

from __future__ import annotations

import math

import pytest
from scripts.algoritmos import calcular_credibilidad, normalizar_valores


def test_min_max_normalisation() -> None:
    assert normalizar_valores([0, 5, 10]) == [0.0, 0.5, 1.0]


def test_constant_series_is_neutral() -> None:
    assert normalizar_valores([7, 7, 7]) == [0.5, 0.5, 0.5]


def test_normalisation_accepts_legacy_strings() -> None:
    assert normalizar_valores(["0", "5).", "10%"]) == [0.0, 0.5, 1.0]


def test_normalisation_ignores_nan_for_range() -> None:
    result = normalizar_valores([0, float("nan"), 10])
    assert result[0] == 0.0
    assert math.isnan(result[1])
    assert result[2] == 1.0


def test_normalisation_rejects_empty() -> None:
    with pytest.raises(ValueError):
        normalizar_valores([])


def test_credibility_of_identical_series_is_one() -> None:
    assert calcular_credibilidad([0, 0.5, 1], [0, 0.5, 1]) == pytest.approx(1.0)


def test_credibility_is_clamped_to_zero() -> None:
    assert calcular_credibilidad([0, 1], [1, 0]) == pytest.approx(0.0)


def test_credibility_ignores_non_finite_pairs() -> None:
    assert calcular_credibilidad([0, float("nan"), 1], [0, 1, 1]) == pytest.approx(1.0)


def test_credibility_rejects_mismatched_lengths() -> None:
    with pytest.raises(ValueError):
        calcular_credibilidad([0, 1], [0])
