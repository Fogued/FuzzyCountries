# Convenience targets for Linux/macOS/WSL. On Windows, run the commands directly
# or use the virtual environment scripts.
.PHONY: install test lint format export data audit check

install:
	python -m pip install -e ".[dev]"

test:
	python -m pytest -q

lint:
	python -m ruff check .
	python -m ruff format --check .

format:
	python -m ruff check . --fix
	python -m ruff format .

export:
	python -m fuzzy_countries.cli export --out exports

data:
	python -m fuzzy_countries.cli build-data --out Data/processed

audit:
	python -m fuzzy_countries.cli audit --out Data/processed/data_quality.csv

check: lint test
