#!/bin/bash
set -e

# Ensure bench command is available
ensure_bench() {
    if ! command -v bench >/dev/null 2>&1; then
        echo "ℹ️ 'bench' command not found. Installing frappe-bench..."
        pip install frappe-bench
    fi
}

# Generate codex.json from available sources
generate_codex_json() {
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
}
