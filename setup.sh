#!/bin/bash
set -e

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# Repos als Submodule klonen
mkdir -p vendor

# vendor repos aus vendor-repos.txt hinzufügen
if [ -f vendor-repos.txt ]; then
    while IFS= read -r line; do
        repo=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$repo" ] && continue
        name=$(basename "$repo" .git)
        target="vendor/$name"
        if [ -d "$target" ]; then
            echo "ℹ️  $target bereits vorhanden, überspringe."
        else
            git submodule add "$repo" "$target"
        fi
        git submodule update --init --recursive "$target"
    done < vendor-repos.txt
fi

# ensure bench command is available
if ! command -v bench >/dev/null 2>&1; then
    echo "ℹ️ 'bench' command not found. Installing frappe-bench..."
    pip install frappe-bench
fi

# vorhandene Submodule initialisieren
git submodule update --init --recursive

# codex.json erzeugen
sources=("apps/")
for dir in vendor/*; do
    [ -d "$dir" ] || continue
    sources+=("$dir/")
done
sources+=("instructions/")

printf '%s\n' "${sources[@]}" \
    | jq -R . \
    | jq -s '{sources: .}' > codex.json

guide="instructions/frappe.md"
if [ -f instructions/frappe_dev.md ]; then
    guide="instructions/frappe_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
