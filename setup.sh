#!/bin/bash
set -e

# ensure jq command is available
if ! command -v jq >/dev/null 2>&1; then
    echo "❌ 'jq' command not found. Please install jq and re-run this script." >&2
    exit 1
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
    # merge additional instructions from template repos
    if [ -d "$dir/instructions" ]; then
        sources+=("$dir/instructions/")
    fi
done
sources+=("instructions/")
if [ -d sample_data ]; then
    sources+=("sample_data/")
fi

printf '%s\n' "${sources[@]}" \
    | jq -R . \
    | jq -s '{sources: .}' > codex.json

guide="instructions/frappe.md"
if [ -f instructions/frappe_dev.md ]; then
    guide="instructions/frappe_dev.md"
fi

echo "✅ Setup abgeschlossen."
echo "➡️  See $guide for next steps."
