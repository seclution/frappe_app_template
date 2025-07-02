#!/usr/bin/env python3
"""Create a simple file index grouped by extension."""
from __future__ import annotations

import argparse
import json
from pathlib import Path

DEFAULT_EXTENSIONS = [
    "py",
    "js",
    "json",
    "html",
    "css",
    "scss",
    "md",
    "vue",
    "jinja",
]


def build_index(root: Path, extensions: list[str] | None = None) -> dict[str, list[str]]:
    """Return mapping of extension -> list of relative file paths."""
    mapping: dict[str, list[str]] = {}
    for path in root.rglob("*"):
        if path.is_file():
            ext = path.suffix.lower().lstrip(".") or "no_ext"
            if extensions is None or ext in extensions:
                mapping.setdefault(ext, []).append(str(path.relative_to(root)))
    return mapping


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(
        description="Create a JSON index of project files grouped by extension"
    )
    parser.add_argument("--root", type=Path, default=Path("."), help="Project root")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("file_index.json"),
        help="Output JSON file",
    )
    args = parser.parse_args(argv)
    index = build_index(args.root, DEFAULT_EXTENSIONS)
    args.output.write_text(json.dumps(index, indent=2))
    print(f"Index written to {args.output}")


if __name__ == "__main__":
    main()
