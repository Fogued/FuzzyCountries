"""Command-line interface for the fuzzy-countries tooling.

Examples::

    fuzzy-countries summary
    fuzzy-countries rank clean_country --top 10
    fuzzy-countries audit
    fuzzy-countries export --out exports
    fuzzy-countries build-data --out Data/processed
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import replace
from pathlib import Path

from . import __version__
from .dataset import (
    DatasetPaths,
    audit_scaled_dataset,
    build_scaled_dataset,
    load_raw_dataset,
    write_processed_datasets,
)
from .export import export_bi_tables
from .model import FuzzyModel, ModelError


def _load_model(path: str | Path) -> FuzzyModel:
    try:
        return FuzzyModel.from_file(path)
    except (OSError, ModelError) as exc:
        raise SystemExit(f"Could not load model from {path}: {exc}") from exc


def cmd_summary(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    summary = model.summary()
    print(f"Source: {model.source}")
    print(f"Countries: {summary['countries']}")
    print(f"Indicators: {summary['indicators']}")
    print(f"Membership functions: {summary['functions']}")
    print(f"Active rules: {summary['rules']}")
    return 0


def cmd_validate(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    problems = model.validate()
    if problems:
        print("Model is NOT valid:")
        for problem in problems:
            print(f"  - {problem}")
        return 1
    print("Model is valid.")
    return 0


def cmd_rank(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    ranked = model.ranking(args.rule, top=args.top)
    width = max(len(country) for country, _ in ranked) if ranked else 0
    print(f"Ranking for {args.rule} ({len(ranked)} countries)")
    for position, (country, score) in enumerate(ranked, start=1):
        print(f"{position:>3}. {country:<{width}}  {score:.4f}")
    return 0


def cmd_audit(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    raw = load_raw_dataset(args.raw)
    scaled = build_scaled_dataset(model)
    audit = audit_scaled_dataset(raw, scaled, model)

    if audit.empty:
        print("No inconsistencies found between the raw data and code.pl.")
        return 0

    summary = (
        audit.groupby("variable", as_index=False)
        .size()
        .rename(columns={"size": "flagged_rows"})
        .sort_values(["flagged_rows", "variable"], ascending=[False, True])
    )
    print(f"Found {len(audit)} inconsistencies in {audit['variable'].nunique()} variables.")
    print()
    print(summary.to_string(index=False))
    print()
    print(audit.to_string(index=False))

    if args.out:
        out = Path(args.out)
        out.parent.mkdir(parents=True, exist_ok=True)
        audit.to_csv(out, index=False)
        print(f"\nWrote {out}")
    return 0


def cmd_export(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    paths = replace(
        DatasetPaths(),
        raw=Path(args.raw),
        country_info=Path(args.country_info),
        happiness=Path(args.happiness),
        renewables=Path(args.renewables),
        temperature=Path(args.temperature),
        suicides=Path(args.suicides),
        credibility=Path(args.credibility),
    )
    outputs = export_bi_tables(
        model,
        paths=paths,
        out_dir=args.out,
        include_history=not args.no_history,
    )
    print(f"Exported {len(outputs)} files to {args.out}:")
    for _name, path in outputs.items():
        rows = sum(1 for _ in path.open(encoding="utf-8")) - 1
        print(f"  - {path.name:<32} {rows:>6} rows")
    return 0


def cmd_build_data(args: argparse.Namespace) -> int:
    model = _load_model(args.code)
    raw = load_raw_dataset(args.raw)
    scaled = build_scaled_dataset(model)
    audit = audit_scaled_dataset(raw, scaled, model)
    outputs = write_processed_datasets(raw, scaled, audit, out_dir=args.out)
    print("Wrote processed datasets:")
    for name, path in outputs.items():
        print(f"  - {name}: {path}")
    if not audit.empty:
        print(f"  - data_quality_summary.csv ({len(audit)} flagged rows)")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="fuzzy-countries",
        description="Python tooling for the FuzzyCountries RFuzzy model.",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )
    parser.add_argument(
        "--code",
        default="code.pl",
        help="Path to the Ciao Prolog model (default: code.pl).",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    summary = subparsers.add_parser("summary", help="Show model dimensions.")
    summary.set_defaults(func=cmd_summary)

    validate = subparsers.add_parser("validate", help="Check model consistency.")
    validate.set_defaults(func=cmd_validate)

    rank = subparsers.add_parser("rank", help="Rank countries for one rule.")
    rank.add_argument("rule", help="Rule name, e.g. clean_country.")
    rank.add_argument("--top", type=int, default=10, help="Number of rows (default: 10).")
    rank.set_defaults(func=cmd_rank)

    audit = subparsers.add_parser(
        "audit",
        help="Compare raw values with the integer values stored in code.pl.",
    )
    audit.add_argument("--raw", default="Data/bd_definitiva.csv", help="Raw dataset (CSV).")
    audit.add_argument("--out", default=None, help="Optional CSV output path.")
    audit.set_defaults(func=cmd_audit)

    export = subparsers.add_parser("export", help="Export a Power BI-friendly star schema.")
    export.add_argument("--out", default="exports", help="Output directory.")
    export.add_argument("--raw", default="Data/bd_definitiva.csv")
    export.add_argument("--country-info", default="Data/covid19countryinfo(4).csv")
    export.add_argument("--happiness", default="Data/World Happiness Report 2021.csv")
    export.add_argument("--renewables", default="Data/renewable-share-energy(2).csv")
    export.add_argument("--temperature", default="Data/temperaturas anuales.csv")
    export.add_argument("--suicides", default="Data/suicidios.csv")
    export.add_argument("--credibility", default="cred/data/credibilidades.txt")
    export.add_argument(
        "--no-history",
        action="store_true",
        help="Skip the yearly indicator history export.",
    )
    export.set_defaults(func=cmd_export)

    build_data = subparsers.add_parser(
        "build-data", help="Write cleaned raw/scaled datasets for analysis."
    )
    build_data.add_argument("--out", default="Data/processed", help="Output directory.")
    build_data.add_argument("--raw", default="Data/bd_definitiva.csv")
    build_data.set_defaults(func=cmd_build_data)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
