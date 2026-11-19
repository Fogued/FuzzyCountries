"""Shared pytest fixtures."""

from __future__ import annotations

from pathlib import Path

import pytest

from fuzzy_countries import FuzzyModel
from fuzzy_countries.dataset import load_raw_dataset

REPO_ROOT = Path(__file__).resolve().parents[1]


@pytest.fixture(scope="session")
def repo_root() -> Path:
    return REPO_ROOT


@pytest.fixture(scope="session")
def model() -> FuzzyModel:
    return FuzzyModel.from_file(REPO_ROOT / "code.pl")


@pytest.fixture(scope="session")
def raw_dataset():
    return load_raw_dataset(REPO_ROOT / "Data/bd_definitiva.csv")
