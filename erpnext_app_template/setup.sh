#!/bin/bash
set -e

# ensure jq command is available
if ! command -v jq >/dev/null 2>&1; then
    echo "❌ 'jq' command not found. Please install jq and re-run this script." >&2
    exit 1
fi

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# vorhandene Submodule initialisieren
git submodule update --init --recursive

# ensure bench command is available
if ! command -v bench >/dev/null 2>&1; then
    echo "ℹ️ 'bench' command not found. Installing frappe-bench..."
    pip install frappe-bench
fi

# codex.json erzeugen
sources=("apps/")
for dir in vendor/*; do
    [ -d "$dir" ] || continue
    sources+=("$dir/")
    if [ -d "$dir/instructions" ]; then
        sources+=("$dir/instructions/")
    fi
done
sources+=("instructions/")
if [ -d sample_data ]; then
    sources+=("sample_data/")
fi

printf '%s\n' "${sources[@]}" | jq -R . | jq -s '{sources: .}' > codex.json

guide="instructions/erpnext.md"
if [ -f instructions/erpnext_dev.md ]; then
    guide="instructions/erpnext_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
