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

# Repos als Submodule klonen
mkdir -p vendor

# vorhandene Submodule initialisieren
git submodule update --init --recursive

# Template-Repositories zuerst klonen
if [ -f template-repos.txt ]; then
    while IFS= read -r line; do
        repo=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$repo" ] && continue
        name=$(basename "$repo" .git)
        target="vendor/$name"
        if [ ! -d "$target" ]; then
            git submodule add "$repo" "$target"
        fi
        git submodule update --init --recursive "$target"
    done < template-repos.txt
fi

# vendor-repos aus Subtemplates zusammenführen (rekursiv)
touch vendor-repos.txt
find vendor -type f -name vendor-repos.txt | while read file; do
    while IFS= read -r repo; do
        repo=$(echo "$repo" | sed 's/#.*//' | xargs)
        [ -z "$repo" ] && continue
        grep -qxF "$repo" vendor-repos.txt || echo "$repo" >> vendor-repos.txt
    done < "$file"
done
sort -u vendor-repos.txt -o vendor-repos.txt

# vendor apps aus apps.json verwenden
if [ -f apps.json ]; then
    jq -r 'to_entries[] | "\(.key) \(.value.repo) \(.value.tag)"' apps.json | while read name repo tag; do
        target="vendor/$name"
        if [ ! -d "$target" ]; then
            git submodule add "$repo" "$target"
        fi
        git -C "$target" fetch --tags
        git -C "$target" checkout "$tag"
        git add "$target"
    done
fi

# additional apps.json files from templates
find vendor -maxdepth 2 -name apps.json | while read file; do
    jq -r 'to_entries[] | "\(.key) \(.value.repo) \(.value.tag)"' "$file" | while read name repo tag; do
        target="vendor/$name"
        if [ ! -d "$target" ]; then
            git submodule add "$repo" "$target"
        fi
        git -C "$target" fetch --tags
        git -C "$target" checkout "$tag"
        git add "$target"
    done
done

# eigentliche vendor-Repos klonen
if [ -f vendor-repos.txt ]; then
    while IFS= read -r line; do
        repo=$(echo "$line" | sed 's/#.*//' | xargs)
        [ -z "$repo" ] && continue
        name=$(basename "$repo" .git)
        target="vendor/$name"
        if [ ! -d "$target" ]; then
            git submodule add "$repo" "$target"
        fi
        git submodule update --init --recursive "$target"
    done < vendor-repos.txt
fi

# ensure bench command is available
ensure_bench

# vorhandene Submodule initialisieren
git submodule update --init --recursive

# codex.json erzeugen
generate_codex_json

guide="instructions/frappe.md"
if [ -f instructions/frappe_dev.md ]; then
    guide="instructions/frappe_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
