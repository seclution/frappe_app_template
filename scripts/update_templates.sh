#!/bin/bash
set -euo pipefail

# Farben für Ausgabe
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

[ -n "${DEBUG:-}" ] && set -x
REPAIR_BROKEN_SUBMODULES="${REPAIR_BROKEN_SUBMODULES:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="${TEMPLATE_FILE:-$ROOT_DIR/templates.txt}"
CODEX_JSON="$ROOT_DIR/codex.json"

# ensure codex.json exists and has templates array
if [ ! -f "$CODEX_JSON" ]; then
    echo '{"templates":[],"sources":[]}' > "$CODEX_JSON"
fi
if ! jq -e '.templates' "$CODEX_JSON" >/dev/null 2>&1; then
    tmp=$(mktemp)
    jq '. + {templates: []}' "$CODEX_JSON" > "$tmp"
    mv "$tmp" "$CODEX_JSON"
fi

echo -e "${BLUE}📄 Reading templates from: ${TEMPLATE_FILE}${RESET}"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}❌ templates.txt not found: $TEMPLATE_FILE${RESET}"
    exit 1
fi

sanitize_line() {
    local line="$1"
    echo "$line" | sed 's/#.*//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

cd "$ROOT_DIR"
changes_made=false
declare -a desired_templates=()

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
    repo="$(sanitize_line "$raw_line")"
    [ -z "$repo" ] && continue

    name="$(basename "$repo" .git)"
    desired_templates+=("$name")
    target="$name"  # nur relativer Pfad!

    echo -e "${BLUE}➡️  Processing: $repo${RESET}"

    if grep -q "path = $target" .gitmodules 2>/dev/null; then
        echo -e "${YELLOW}🔄 Submodule exists: $target. Checking...${RESET}"

        # If the submodule was cloned without running `git submodule update --init`
        # the directory may exist but not be populated with a working tree.
        # Attempt to initialise it so further git commands succeed.
        git submodule update --init "$target" >/dev/null 2>&1 || true

        if [ ! -d "$target" ]; then
            echo -e "${YELLOW}⚠️  Directory for submodule '$target' is missing!${RESET}"
            if [ "$REPAIR_BROKEN_SUBMODULES" = true ]; then
                echo -e "${YELLOW}🛠 Attempting to remove and re-add broken submodule $target...${RESET}"
                git submodule deinit -f "$target" || true
                git rm -f "$target" || true
                rm -rf ".git/modules/$target"
                git add .gitmodules || true
                git commit -am "Remove broken submodule $target" || true
                rm -rf "$target"
                echo -e "${GREEN}➕ Re-adding submodule $target...${RESET}"
                if git submodule add "$repo" "$target"; then
                    echo -e "${GREEN}✅ Re-added submodule: $target${RESET}"
                    changes_made=true
                    continue
                else
                    echo -e "${RED}❌ Failed to re-add submodule: $target${RESET}"
                    continue
                fi
            else
                echo -e "${RED}❌ Submodule $target is broken. Run with REPAIR_BROKEN_SUBMODULES=true to auto-fix.${RESET}"
                continue
            fi
        fi

        pushd "$target" > /dev/null
        git fetch origin &> /dev/null
        LOCAL_COMMIT=$(git rev-parse HEAD)
        REMOTE_COMMIT=$(git rev-parse origin/HEAD || git rev-parse origin/master || echo "")
        popd > /dev/null

        if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
            echo -e "${GREEN}⬆️  Updating submodule $target from $LOCAL_COMMIT → $REMOTE_COMMIT${RESET}"
            git submodule update --remote "$target"
            changes_made=true
        else
            echo -e "${GREEN}✅ Submodule $target already up-to-date${RESET}"
        fi
    elif [ -d "$target" ]; then
        echo -e "${YELLOW}⚠️  Directory $target exists but is not a submodule. Skipping...${RESET}"
    else
        echo -e "${GREEN}➕ Adding new submodule $target...${RESET}"
        if git submodule add "$repo" "$target"; then
            echo -e "${GREEN}✅ Added submodule: $target${RESET}"
            changes_made=true
        else
            echo -e "${RED}❌ Failed to add submodule: $target${RESET}"

            # 🧹 Check auf verwaistes .git/modules-Verzeichnis
            if [ -d ".git/modules/$target" ]; then
                echo -e "${YELLOW}🧹 Detected leftover .git/modules/$target – cleaning up and retrying...${RESET}"
                rm -rf "$target" 2>/dev/null || true
                rm -rf ".git/modules/$target" 2>/dev/null || true

                if git submodule add "$repo" "$target"; then
                    echo -e "${GREEN}✅ Re-added submodule after cleanup: $target${RESET}"
                    changes_made=true
                else
                    echo -e "${RED}❌ Still failed to add submodule after cleanup: $target${RESET}"
                fi
            fi
        fi
    fi

    if [ -d "$target/instructions" ]; then
        echo -e "${BLUE}📘 Syncing instructions from $target/instructions${RESET}"
        mkdir -p "$ROOT_DIR/instructions/_$name"
        rsync -a --delete "$target/instructions/" "$ROOT_DIR/instructions/_$name/"
    fi

    if ! jq -e --arg n "$name" '.templates | index($n)' "$CODEX_JSON" >/dev/null; then
        tmp=$(mktemp)
        jq --arg n "$name" '.templates += [$n]' "$CODEX_JSON" > "$tmp"
        mv "$tmp" "$CODEX_JSON"
    fi
done < "$TEMPLATE_FILE"

# remove templates present in codex.json but not in the desired list
if [ -f "$CODEX_JSON" ]; then
    readarray -t current_templates < <(jq -r '.templates[]?' "$CODEX_JSON")
    for tmpl in "${current_templates[@]}"; do
        if [[ ! " ${desired_templates[*]} " =~ " ${tmpl} " ]]; then
            bash "$SCRIPT_DIR/remove_template.sh" "$tmpl"
            changes_made=true
        fi
    done
fi

# remove duplicates and sort templates list
if [ -f "$CODEX_JSON" ]; then
    tmp=$(mktemp)
    jq '.templates |= sort | unique' "$CODEX_JSON" > "$tmp" && mv "$tmp" "$CODEX_JSON"
fi

if $changes_made; then
    echo -e "${GREEN}✅ Templates updated successfully.${RESET}"
    # rebuild apps.json based on updated templates
    if [ -f "$SCRIPT_DIR/update_vendors.sh" ]; then
        bash "$SCRIPT_DIR/update_vendors.sh"
    fi
else
    echo -e "${YELLOW}ℹ️  No changes detected. Everything is up-to-date.${RESET}"
fi
