#!/bin/bash
set -e

# Prevent execution inside the frappe_app_template submodule
toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ "$toplevel" == *"/frappe_app_template" ]]; then
  echo "⛔ ERROR: You are inside the frappe_app_template submodule."
  echo "💡 Please run this script from the root of your app repository, not from inside the template."
  exit 1
fi

# Determine the script and parent directories
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
WORKFLOW_TEMPLATE_DIR="$SCRIPT_DIR/workflow_templates"

# When used as a submodule, copy workflow files (and requirements.txt) to the
# parent repository
if [ -d "$PARENT_DIR/.git" ] && [ "$PARENT_DIR" != "$SCRIPT_DIR" ]; then
    for wf in "$WORKFLOW_TEMPLATE_DIR"/*.yml; do
        [ -f "$wf" ] || continue
        target="$PARENT_DIR/.github/workflows/$(basename "$wf")"
        mkdir -p "$(dirname "$target")"
        cp "$wf" "$target"
    done
    if [ ! -f "$PARENT_DIR/requirements.txt" ]; then
        cp "$SCRIPT_DIR/requirements.txt" "$PARENT_DIR/requirements.txt"
    fi
    if [ ! -f "$PARENT_DIR/requirements-dev.txt" ] && [ -f "$SCRIPT_DIR/requirements-dev.txt" ]; then
        cp "$SCRIPT_DIR/requirements-dev.txt" "$PARENT_DIR/requirements-dev.txt"
    fi
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        cp -r "$SCRIPT_DIR/scripts" "$PARENT_DIR/"
        chmod +x "$PARENT_DIR"/scripts/*.sh
    fi
    if [ "$PARENT_DIR" != "$SCRIPT_DIR" ] && [ ! -f "$PARENT_DIR/.gitignore" ] && [ -f "$SCRIPT_DIR/.gitignore" ]; then
        cp "$SCRIPT_DIR/.gitignore" "$PARENT_DIR/.gitignore"
    fi

    CONFIG_TARGET="$PARENT_DIR"
else
    CONFIG_TARGET="$SCRIPT_DIR"
fi

# Ensure .gitmodules exists so that workflows using submodules don't fail
if [ ! -f "$CONFIG_TARGET/.gitmodules" ]; then
    git submodule init 2>/dev/null || touch "$CONFIG_TARGET/.gitmodules"
fi

# Determine app name
APP_NAME="${APP_NAME:-$1}"
if [ -z "$APP_NAME" ]; then
    APP_NAME="$(basename "$CONFIG_TARGET")"
fi

# Ensure sample_data directory exists
mkdir -p "$CONFIG_TARGET/sample_data"

# Ensure vendor directory exists for workflows
mkdir -p "$CONFIG_TARGET/vendor"

# Ensure core instructions directory and README
mkdir -p "$CONFIG_TARGET/instructions/_core"
CORE_README="$CONFIG_TARGET/instructions/_core/README.md"
if [ ! -f "$CORE_README" ]; then
    cat > "$CORE_README" <<'EOF'
# 📚 Codex Instructions System

Dies ist die zentrale, nie löschbare Anleitungsbasis für Codex-gestützte Entwicklung.

## Funktionsweise

- Jedes App-Template enthält ein eigenes `instructions/`-Verzeichnis
- Beim Clonen eines Templates (siehe `vendors.txt`) werden diese nach `instructions/_<slug>/` kopiert
- Beim Entfernen eines Templates wird auch `instructions/_<template-name>/` gelöscht

## Ziel

Anhand dieser Anleitungen kann Codex automatisch passende Prompt-Ketten generieren, z. B.:

> „Erstelle eine App mit Website zur Eingabe von Projektdaten, die in ERPNext gespeichert werden“

→ Erkennt Schlüsselwörter (`website`, `erpnext`)
→ nutzt passende Inhalte aus:
`_core/`, `_erpnext-website-template/`, `_erpnext-template/`

## Beispielstruktur

```
instructions/
├── _core/                     # Zentrale Hinweise (nie löschen)
├── _erpnext-template/        # Von Template eingebracht
├── _erpnext-website-template/
│   ├── 00_overview.md
│   └── prompts/
│       ├── generate_webform.md
│       └── sync_with_erpnext.md
```

Diese Dateien werden später von Codex ausgelesen, um automatisch die passenden Entwicklungs-Prompts zu generieren.
EOF
fi

# Create example configuration files if missing
if [ ! -f "$CONFIG_TARGET/vendors.txt" ]; then
    cp "$SCRIPT_DIR/vendors.txt" "$CONFIG_TARGET/vendors.txt"
fi

if [ ! -f "$CONFIG_TARGET/apps.json" ]; then
    cp "$SCRIPT_DIR/apps.json" "$CONFIG_TARGET/apps.json"
fi

if [ ! -f "$CONFIG_TARGET/custom_vendors.json" ]; then
    cat > "$CONFIG_TARGET/custom_vendors.json" <<'JSON'
{
  "example_app": {
    "repo": "https://github.com/example/example_app",
    "branch": "v1.0.0"
  }
}
JSON
fi


if [ ! -f "$CONFIG_TARGET/codex.json" ]; then
    cat > "$CONFIG_TARGET/codex.json" <<'JSON'
{
  "_comment": "Directories indexed by Codex. Adjust paths as needed.",
  "sources": [
    "app/",
    "vendor/bench/",
    "vendor/frappe/",
    "instructions/",
    "sample_data/"
  ],
  "templates": []
}
JSON
fi

# ensure templates field exists
if ! jq -e '.templates' "$CONFIG_TARGET/codex.json" >/dev/null 2>&1; then
    tmp=$(mktemp)
    jq '. + {templates: []}' "$CONFIG_TARGET/codex.json" > "$tmp"
    mv "$tmp" "$CONFIG_TARGET/codex.json"
fi


# Ensure app skeleton exists and fill missing files
APP_DIR="$CONFIG_TARGET/app/$APP_NAME"
mkdir -p "$APP_DIR" "$APP_DIR/config" "$APP_DIR/templates" "$APP_DIR/$APP_NAME"

if [ ! -f "$APP_DIR/__init__.py" ]; then
    echo "__version__ = '0.0.1'" > "$APP_DIR/__init__.py"
fi

if [ ! -f "$APP_DIR/modules.txt" ]; then
    echo "$APP_NAME" > "$APP_DIR/modules.txt"
fi

if [ ! -f "$APP_DIR/hooks.py" ]; then
    cat > "$APP_DIR/hooks.py" <<EOF
app_name = "$APP_NAME"
app_title = "$APP_NAME"
app_publisher = "Unknown"
app_description = "App generated by setup.sh"
app_email = "email@example.com"
app_license = "MIT"
EOF
fi

touch "$APP_DIR/config/__init__.py"
touch "$APP_DIR/templates/__init__.py"
touch "$APP_DIR/$APP_NAME/__init__.py"

if [ ! -f "$CONFIG_TARGET/app/README.md" ]; then
    cat > "$CONFIG_TARGET/app/README.md" <<EOF
### $APP_NAME

App generated by setup.sh
EOF
fi

if [ ! -f "$CONFIG_TARGET/app/license.txt" ]; then
    cat > "$CONFIG_TARGET/app/license.txt" <<'EOF'
MIT License

Copyright (c) [year] [fullname]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
fi

if [ ! -f "$CONFIG_TARGET/app/pyproject.toml" ]; then
    cat > "$CONFIG_TARGET/app/pyproject.toml" <<EOF
[project]
name = "$APP_NAME"
authors = [
    { name = "Your Name", email = "email@example.com" }
]
description = "App generated by setup.sh"
requires-python = ">=3.10"
readme = "README.md"
dynamic = ["version"]
dependencies = []

[build-system]
requires = ["flit_core >=3.4,<4"]
build-backend = "flit_core.buildapi"
EOF
fi

if [ ! -f "$CONFIG_TARGET/app/setup.py" ]; then
    cat > "$CONFIG_TARGET/app/setup.py" <<EOF
from setuptools import find_packages, setup

with open("app/$APP_NAME/__init__.py") as f:
    for line in f:
        if line.startswith("__version__"):
            version = line.split("=")[1].strip().strip("'\"")
            break
    else:
        version = "0.0.1"

setup(
    name="$APP_NAME",
    version=version,
    packages=find_packages("app"),
    package_dir={"": "app"},
    include_package_data=True,
    zip_safe=False,
)
EOF
fi

echo "✅ Setup complete."
