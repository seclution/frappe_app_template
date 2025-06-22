#!/bin/bash
set -e

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# Repos als Submodule klonen
mkdir -p vendor

# ensure bench command is available
if ! command -v bench >/dev/null 2>&1; then
    echo "ℹ️ 'bench' command not found. Installing frappe-bench..."
    pip install frappe-bench
fi

# initialize submodules
git submodule update --init --recursive

# codex.json erzeugen
sources=("apps/")
for dir in vendor/*; do
    [ -d "$dir" ] || continue
    sources+=("$dir/")
done

printf '%s\n' "${sources[@]}" \
    | jq -R . \
    | jq -s '{sources: .}' > codex.json

guide="instructions/frappe.md"
if [ -f instructions/frappe_dev.md ]; then
    guide="instructions/frappe_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
