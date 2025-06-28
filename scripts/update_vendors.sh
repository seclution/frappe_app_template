#!/bin/bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0

# Prevent execution inside the frappe_app_template submodule
toplevel=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ "$toplevel" == *"/frappe_app_template" ]]; then
  echo "⛔ ERROR: You are inside the frappe_app_template submodule."
  echo "💡 Please run this script from the root of your app repository, not from inside the template."
  exit 1
fi

# Colors for output
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

[ -n "${DEBUG:-}" ] && set -x

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VENDOR_DIR="$ROOT_DIR/vendor"

mkdir -p "$VENDOR_DIR"

# list of base apps defined in apps.json
BASE_APPS=(bench frappe)


# gather apps.json files from submodules
APP_FILES=()
while IFS= read -r f; do
    APP_FILES+=("$f")
done < <(find "$ROOT_DIR" -mindepth 2 -maxdepth 3 -name apps.json 2>/dev/null | sort)

# gather custom_vendors.json files as well
CUSTOM_FILES=()
if [ -f "$ROOT_DIR/custom_vendors.json" ]; then
    CUSTOM_FILES+=("$ROOT_DIR/custom_vendors.json")
fi
while IFS= read -r f; do
    CUSTOM_FILES+=("$f")
done < <(find "$ROOT_DIR" -mindepth 2 -maxdepth 3 -name custom_vendors.json 2>/dev/null | sort)

if [ "${#APP_FILES[@]}" -eq 0 ] && [ "${#CUSTOM_FILES[@]}" -eq 0 ]; then
    echo -e "${RED}❌ No vendor definition files found${RESET}"
    exit 1
fi

# associative arrays for repo url and tag
declare -A REPOS
declare -A TAGS
declare -A CUSTOM_REPOS
declare -A CUSTOM_TAGS

# read base apps from apps.json
if [ -f "$ROOT_DIR/apps.json" ]; then
    for base in "${BASE_APPS[@]}"; do
        if jq -e --arg app "$base" '.[$app]' "$ROOT_DIR/apps.json" >/dev/null 2>&1; then
            repo=$(jq -r --arg app "$base" '.[$app].repo' "$ROOT_DIR/apps.json")
            tag=$(jq -r --arg app "$base" '.[$app].branch // .[$app].tag' "$ROOT_DIR/apps.json")
            REPOS["$base"]="$repo"
            TAGS["$base"]="$tag"
        fi
    done
fi

for file in "${APP_FILES[@]}"; do
    echo -e "${BLUE}📄 Reading $file${RESET}"
    while IFS='|' read -r name repo tag; do
        [ -z "$name" ] && continue
        REPOS["$name"]="$repo"
        TAGS["$name"]="$tag"
    done < <(jq -r 'to_entries[] | "\(.key)|\(.value.repo)|\(.value.branch // .value.tag)"' "$file")
done

for file in "${CUSTOM_FILES[@]}"; do
    echo -e "${BLUE}📄 Reading $file${RESET}"
    while IFS='|' read -r name repo tag; do
        [ -z "$name" ] && continue
        REPOS["$name"]="$repo"
        TAGS["$name"]="$tag"
        CUSTOM_REPOS["$name"]="$repo"
        CUSTOM_TAGS["$name"]="$tag"
    done < <(jq -r 'to_entries[] | "\(.key)|\(.value.repo)|\(.value.tag // .value.branch)"' "$file")
done

changes=false

for app in "${!REPOS[@]}"; do
    repo="${REPOS[$app]}"
    tag="${TAGS[$app]}"
    target="$VENDOR_DIR/$app"

    echo -e "${BLUE}➡️  Processing $app ($tag)${RESET}"

    if grep -q "path = vendor/$app" "$ROOT_DIR/.gitmodules" 2>/dev/null; then
        if ! git submodule update --init "vendor/$app"; then
            echo -e "${YELLOW}⚠️  Failed to update $app, skipping${RESET}"
            unset 'REPOS[$app]' 'TAGS[$app]'
            continue
        fi
    else
        if ! git submodule add "$repo" "vendor/$app"; then
            echo -e "${YELLOW}⚠️  Failed to add $app from $repo, skipping${RESET}"
            unset 'REPOS[$app]' 'TAGS[$app]'
            continue
        fi
        changes=true
    fi

    if pushd "$target" >/dev/null; then
        git fetch --tags || echo -e "${YELLOW}⚠️  Failed to fetch tags for $app${RESET}"
        if ! git checkout "$tag"; then
            echo -e "${YELLOW}⚠️  Tag $tag not found for $app, skipping${RESET}"
            popd >/dev/null
            unset 'REPOS[$app]' 'TAGS[$app]'
            continue
        fi
        popd >/dev/null
    else
        echo -e "${YELLOW}⚠️  Missing directory for $app, skipping${RESET}"
        unset 'REPOS[$app]' 'TAGS[$app]'
        continue
    fi
done

# prune submodules not present in current config
if [ -f "$ROOT_DIR/.gitmodules" ]; then
    while IFS= read -r path; do
        # only manage submodules under vendor/
        [[ "$path" == vendor/* ]] || continue
        app="$(basename "$path")"
        if [ -z "${REPOS[$app]+x}" ]; then
            echo -e "${YELLOW}🗑 Removing obsolete submodule $app${RESET}"
            git submodule deinit -f "$path" || true
            git rm -f "$path" || true
            rm -rf ".git/modules/$path" "$path"
            changes=true
        fi
    done < <(git config --file "$ROOT_DIR/.gitmodules" --get-regexp path | awk '{print $2}')
fi

# prune leftover directories without submodules
if [ -d "$VENDOR_DIR" ]; then
    for dir in "$VENDOR_DIR"/*; do
        [ -d "$dir" ] || continue
        app="$(basename "$dir")"
        if [ -z "${REPOS[$app]+x}" ]; then
            echo -e "${YELLOW}🗑 Removing obsolete directory $dir${RESET}"
            rm -rf "$dir"
            changes=true
        fi
    done
fi

# rebuild apps.json
filter='{}'
for app in "${!REPOS[@]}"; do
    repo="${REPOS[$app]}"
    tag="${TAGS[$app]}"
    filter="$filter | .[\"$app\"]={repo:\"$repo\",branch:\"$tag\"}"
 done
jq -n "$filter" > "$ROOT_DIR/apps.json"

# rebuild custom_vendors.json
custom_filter='{}'
for app in "${!CUSTOM_REPOS[@]}"; do
    repo="${CUSTOM_REPOS[$app]}"
    tag="${CUSTOM_TAGS[$app]}"
    custom_filter="$custom_filter | .[\"$app\"]={repo:\"$repo\",tag:\"$tag\"}"
done
jq -n "$custom_filter" > "$ROOT_DIR/custom_vendors.json"

# rebuild codex.json
sources=("app/")
for app in "${!REPOS[@]}"; do
    sources+=("vendor/$app/")
 done
sources+=("instructions/" "sample_data/")


# preserve existing templates list from codex.json if present
existing_templates="[]"
if [ -f "$ROOT_DIR/codex.json" ]; then
    existing_templates=$(jq -r 'if (.templates|type=="array") then .templates else [] end' "$ROOT_DIR/codex.json" 2>/dev/null || echo "[]")
fi

sources_json=$(printf '%s\n' "${sources[@]}" | jq -R '.' | jq -s '.')

jq -n --argjson s "$sources_json" --argjson t "$existing_templates" '{"_comment":"Directories indexed by Codex. Adjust paths as needed.","sources":$s,"templates":$t}' > "$ROOT_DIR/codex.json"

echo -e "${GREEN}✅ Vendor repositories updated.${RESET}"
