#!/bin/bash
set -e

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# Repos als Submodule klonen
mkdir -p vendor

if [ -f vendor-repos.txt ]; then
    while read -r repo; do
        # leere Zeilen ignorieren
        [ -z "$repo" ] && continue
        name=$(basename "$repo" .git)
        target="vendor/$name"
        if [ ! -d "$target" ]; then
            git submodule add "$repo" "$target"
            git submodule update --init --recursive "$target"
        fi
    done < vendor-repos.txt
fi

# codex.json erzeugen
sources=("apps/")
for dir in vendor/*; do
    [ -d "$dir" ] || continue
    sources+=("$dir/")
done

printf '%s\n' "${sources[@]}" \
    | jq -R . \
    | jq -s '{sources: .}' > codex.json

echo "✅ Setup abgeschlossen."
