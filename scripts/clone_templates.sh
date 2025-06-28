#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="${TEMPLATE_FILE:-$ROOT_DIR/templates.txt}"
VENDOR_DIR="$ROOT_DIR/vendor"
INSTRUCTIONS_DIR="$ROOT_DIR/instructions"
CODEX_JSON="$ROOT_DIR/codex.json"

mkdir -p "$VENDOR_DIR" "$INSTRUCTIONS_DIR"

# ensure codex.json exists and has templates array
if [ ! -f "$CODEX_JSON" ]; then
    echo '{"templates":[],"sources":[]}' > "$CODEX_JSON"
fi
if ! jq -e '.templates' "$CODEX_JSON" >/dev/null 2>&1; then
    tmp=$(mktemp)
    jq '. + {templates: []}' "$CODEX_JSON" > "$tmp"
    mv "$tmp" "$CODEX_JSON"
fi

readarray -t existing_templates < <(jq -r '.templates[]' "$CODEX_JSON")

sanitize() {
    echo "$1" | sed 's/#.*//' | sed 's/^\s*//;s/\s*$//'
}

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
    repo="$(sanitize "$raw_line")"
    [ -z "$repo" ] && continue
    name="$(basename "$repo" .git)"
    target="vendor/$name"
    echo "--> processing $name"

    if ! grep -q "path = $target" "$ROOT_DIR/.gitmodules" 2>/dev/null; then
        git submodule add "$repo" "$target" || true
    fi

    if [ -d "$target/instructions" ]; then
        mkdir -p "$INSTRUCTIONS_DIR/_$name"
        rsync -a "$target/instructions/" "$INSTRUCTIONS_DIR/_$name/"
    fi

    if ! jq -e --arg n "$name" '.templates | index($n)' "$CODEX_JSON" >/dev/null; then
        tmp=$(mktemp)
        jq --arg n "$name" '.templates += [$n]' "$CODEX_JSON" > "$tmp"
        mv "$tmp" "$CODEX_JSON"
    fi

done < "$TEMPLATE_FILE"

# remove duplicates just in case
uniq_tmp=$(mktemp)
jq '.templates |= unique' "$CODEX_JSON" > "$uniq_tmp" && mv "$uniq_tmp" "$CODEX_JSON"

echo "Templates cloned and instructions synced."
