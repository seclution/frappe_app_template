#!/bin/bash
set -e

# Load shared helper functions
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/../scripts/common_setup.sh" ]; then
    source "$SCRIPT_DIR/../scripts/common_setup.sh"
else
    source "$SCRIPT_DIR/scripts/common_setup.sh"
fi

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# vorhandene Submodule initialisieren
git submodule update --init --recursive

# ensure bench command is available
ensure_bench

# codex.json erzeugen
generate_codex_json

guide="instructions/erpnext.md"
if [ -f instructions/erpnext_dev.md ]; then
    guide="instructions/erpnext_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
