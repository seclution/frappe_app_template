#!/usr/bin/env python3
"""Create or update a Frappe app folder similar to `bench new-app` output."""
from __future__ import annotations

import argparse
from pathlib import Path


def humanize(name: str) -> str:
    """Convert ``my_app`` to ``My App``."""
    parts = name.replace("-", "_").split("_")
    return " ".join(p.title() for p in parts if p)


def ensure_file(path: Path, content: str) -> None:
    """Create ``path`` with ``content`` only if it doesn't already exist."""
    if path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def create_app(root: Path, app_name: str) -> None:
    app_title = humanize(app_name)
    app_dir = root

    (app_dir / "config").mkdir(parents=True, exist_ok=True)
    (app_dir / "templates" / "pages").mkdir(parents=True, exist_ok=True)
    (app_dir / app_name).mkdir(parents=True, exist_ok=True)

    ensure_file(app_dir / "README.md", README.format(app_name=app_name, app_title=app_title))
    ensure_file(app_dir / "license.txt", MIT_LICENSE)
    ensure_file(app_dir / "pyproject.toml", PYPROJECT.format(app_name=app_name))
    ensure_file(app_dir / "patches.txt", PATCHES)
    ensure_file(app_dir / "modules.txt", f"{app_title}\n")
    ensure_file(app_dir / "hooks.py", HOOKS.format(app_name=app_name, app_title=app_title))
    ensure_file(app_dir / "__init__.py", "")
    ensure_file(app_dir / app_name / "__init__.py", "__version__ = '0.0.1'\n")
    ensure_file(app_dir / "config" / "__init__.py", "")
    ensure_file(app_dir / "templates" / "__init__.py", "")
    ensure_file(app_dir / "templates" / "pages" / "__init__.py", "")


README = """### {app_title}

for structure

### Installation

You can install this app using the [bench](https://github.com/frappe/bench) CLI:

```bash
cd $PATH_TO_YOUR_BENCH
bench get-app $URL_OF_THIS_REPO --branch develop
bench install-app {app_name}
```

### Contributing

This app uses `pre-commit` for code formatting and linting. Please [install pre-commit](https://pre-commit.com/#installation) and enable it for this repository:

```bash
cd apps/{app_name}
pre-commit install
```

Pre-commit is configured to use the following tools for checking and formatting your code:

- ruff
- eslint
- prettier
- pyupgrade

### CI

This app can use GitHub Actions for CI. The following workflows are configured:

- CI: Installs this app and runs unit tests on every push to `develop` branch.
- Linters: Runs [Frappe Semgrep Rules](https://github.com/frappe/semgrep-rules) and [pip-audit](https://pypi.org/project/pip-audit/) on every pull request.

### License

mit
"""

MIT_LICENSE = """MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

PYPROJECT = """[project]
name = \"{app_name}\"
authors = [
    {{ name = \"Your Name\", email = \"email@example.com\" }}
]
description = \"for structure\"
requires-python = \">=3.10\"
readme = \"README.md\"
dynamic = [\"version\"]
dependencies = [
    # \"frappe~=15.0.0\" # Installed and managed by bench.
]

[build-system]
requires = [\"flit_core >=3.4,<4\"]
build-backend = \"flit_core.buildapi\"

# These dependencies are only installed when developer mode is enabled
[tool.bench.dev-dependencies]
# package_name = \"~=1.1.0\"

[tool.ruff]
line-length = 110
target-version = \"py310\"

[tool.ruff.lint]
select = [
    \"F\",
    \"E\",
    \"W\",
    \"I\",
    \"UP\",
    \"B\",
    \"RUF\",
]
ignore = [
    \"B017\",
    \"B018\",
    \"B023\",
    \"B904\",
    \"E101\",
    \"E402\",
    \"E501\",
    \"E741\",
    \"F401\",
    \"F403\",
    \"F405\",
    \"F722\",
    \"W191\",
]
typing-modules = [\"frappe.types.DF\"]

[tool.ruff.format]
quote-style = \"double\"
indent-style = \"tab\"
docstring-code-format = true
"""

PATCHES = """[pre_model_sync]
# Patches added in this section will be executed before doctypes are migrated
# Read docs to understand patches: https://frappeframework.com/docs/v14/user/en/database-migrations

[post_model_sync]
# Patches added in this section will be executed after doctypes are migrated"""

HOOKS = """app_name = \"{app_name}\"
app_title = \"{app_title}\"
app_publisher = \"Your Name\"
app_description = \"for structure\"
app_email = \"email@example.com\"
app_license = \"mit\"
"""


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description="Create or update frappe app folder")
    parser.add_argument("app_name", help="Name of the app")
    parser.add_argument("--root", type=Path, default=Path("app"), help="Parent directory for app")
    return parser.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    create_app(Path(args.root), args.app_name)


if __name__ == "__main__":
    main()
