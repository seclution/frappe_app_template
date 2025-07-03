#!/bin/bash
set -e

if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq is required but not installed. Please install jq and retry." >&2
  exit 1
fi

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
        if [ ! -f "$target" ]; then
            cp "$wf" "$target"
        fi
    done
    if [ ! -f "$PARENT_DIR/requirements.txt" ]; then
        cp "$SCRIPT_DIR/requirements.txt" "$PARENT_DIR/requirements.txt"
    fi
    if [ ! -f "$PARENT_DIR/requirements-dev.txt" ] && [ -f "$SCRIPT_DIR/requirements-dev.txt" ]; then
        cp "$SCRIPT_DIR/requirements-dev.txt" "$PARENT_DIR/requirements-dev.txt"
    fi
    if [ -d "$SCRIPT_DIR/scripts" ]; then
        mkdir -p "$PARENT_DIR/scripts"
        for sf in "$SCRIPT_DIR"/scripts/*; do
            [ -f "$sf" ] || continue
            target="$PARENT_DIR/scripts/$(basename "$sf")"
            if [ ! -f "$target" ]; then
                cp "$sf" "$target"
            fi
        done
        chmod +x "$PARENT_DIR"/scripts/*.sh 2>/dev/null || true
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

# 📚 Agent Instruction System

Dies ist die zentrale, nie löschbare Anleitungsbasis für das agentbasierte Entwicklungssystem.

## Funktionsweise

- Jedes App-Template enthält ein eigenes `instructions/`-Verzeichnis
- Beim Clonen eines Templates (siehe `vendors.txt`) werden diese nach `instructions/_<slug>/` kopiert
- Beim Entfernen eines Templates wird auch `instructions/_<template-name>/` gelöscht

## Ziel

Diese Anleitungen ermöglichen es dem agentbasierten System, automatisch passende Prompt-Ketten zusammenzustellen, z. B.:

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

Diese Dateien werden später vom agentbasierten System ausgelesen, um automatisch die passenden Entwicklungs-Prompts zu generieren.

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

# Ensure app skeleton exists (matching bench new-app)
echo "ℹ️  Creating app skeleton (includes app/.gitignore)"
python3 "$CONFIG_TARGET/scripts/new_frappe_app_folder.py" "$APP_NAME" --root "$CONFIG_TARGET/app"

# Build initial documentation index
python3 "$CONFIG_TARGET/scripts/generate_index.py"

echo "✅ Setup complete."
