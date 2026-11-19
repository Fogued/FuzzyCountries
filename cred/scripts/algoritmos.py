"""Credibility algorithms used by the legacy Python pipeline.

The original code compared the truth values produced by RFuzzy with a
normalised version of the real indicator and returned ``1 - MAE``.  The
functions below keep that behaviour but handle empty, constant or partially
missing series instead of crashing.
"""

from __future__ import annotations

from collections.abc import Iterable, Sequence

import numpy as np
from sklearn.metrics import mean_absolute_error


def _to_float_array(values: Iterable[float | str]) -> np.ndarray:
    cleaned: list[float] = []
    for value in values:
        if isinstance(value, str):
            value = value.replace(").", "").replace("%", "").replace(",", "").strip()
        cleaned.append(float(value))
    return np.asarray(cleaned, dtype=float)


def calcular_credibilidad(
    valores_reales: Sequence[float] | Iterable[float],
    valores_difusos: Sequence[float] | Iterable[float],
) -> float:
    """Return ``1 - MAE`` for two series of truth values in ``[0, 1]``.

    Non-finite pairs are ignored.  The result is clamped to ``[0, 1]``.
    """
    real = _to_float_array(valores_reales)
    fuzzy = _to_float_array(valores_difusos)
    if real.size == 0 or fuzzy.size == 0:
        raise ValueError("Cannot compute credibility from empty series")
    if real.shape != fuzzy.shape:
        raise ValueError(f"Series must have the same length ({real.size} != {fuzzy.size})")

    mask = np.isfinite(real) & np.isfinite(fuzzy)
    if not mask.any():
        return 0.0

    mae = mean_absolute_error(real[mask], fuzzy[mask])
    return float(np.clip(1.0 - mae, 0.0, 1.0))


def normalizar_valores(valores: Sequence[float] | Iterable[float]) -> list[float]:
    """Min-max normalise a series into ``[0, 1]``.

    A constant series has no range, so it is mapped to ``0.5`` (neutral)
    instead of raising a division-by-zero error.  Non-finite values are
    ignored when computing the range and preserved in the output as ``nan``.
    """
    array = _to_float_array(valores)
    if array.size == 0:
        raise ValueError("Cannot normalise an empty series")

    mask = np.isfinite(array)
    if not mask.any():
        return [float("nan")] * array.size

    minimum = float(array[mask].min())
    maximum = float(array[mask].max())
    if maximum == minimum:
        return [0.5] * array.size

    normalised = (array - minimum) / (maximum - minimum)
    return np.clip(normalised, 0.0, 1.0).tolist()
