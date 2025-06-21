#!/bin/bash
set -e

echo "🔧 Initialisiere App-Entwicklungsumgebung..."

# Repos klonen
mkdir -p vendor
cd vendor

if [ -f ../vendor-repos.txt ]; then
    while read -r repo; do
        name=$(basename "$repo" .git)
        if [ -n "$repo" ] && [ ! -d "$name" ]; then
            git clone "$repo"
        fi
    done < ../vendor-repos.txt
fi

cd ..

# codex.json erzeugen
cat > codex.json <<'JSON'
{
  "sources": [
    "apps/",
    "vendor/frappe/",
    "vendor/erpnext/"
  ]
}
JSON

echo "✅ Setup abgeschlossen."
