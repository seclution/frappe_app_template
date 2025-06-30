#!/bin/bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VENDOR_DIR="$ROOT_DIR/vendor"
VENDORS_FILE="${VENDORS_FILE:-$ROOT_DIR/vendors.txt}"
PROFILES_DIR="${PROFILES_DIR:-$ROOT_DIR/vendor_profiles}"

# fallback to template-provided profiles when none exist in the project
if [ ! -d "$PROFILES_DIR" ]; then
  if [ -d "$ROOT_DIR/frappe_app_template/vendor_profiles" ]; then
    PROFILES_DIR="$ROOT_DIR/frappe_app_template/vendor_profiles"
  elif [ -d "$ROOT_DIR/template/vendor_profiles" ]; then
    PROFILES_DIR="$ROOT_DIR/template/vendor_profiles"
  fi
fi
CODEX_JSON="$ROOT_DIR/codex.json"

mkdir -p "$VENDOR_DIR"
cd "$ROOT_DIR"

# read vendors list
readarray -t RAW_LINES < <(grep -v '^#' "$VENDORS_FILE" 2>/dev/null | sed '/^\s*$/d')

# integration data
declare -A REPOS
declare -A BRANCHES
declare -A TAGS
declare -A APP_INFO
declare -A PATHS
declare -A KEEP

recognized=()
installed=()
updated=()
removed=()

for line in "${RAW_LINES[@]}"; do
  IFS='|' read -r part1 part2 part3 part4 <<< "$line"
  slug=""
  repo=""
  branch=""
  tag=""
  if [[ -n "$part4" ]]; then
    slug="$part1"
    repo="$part2"
    branch="$part3"
    tag="$part4"
  elif [[ -n "$part3" ]]; then
    slug="$part1"
    repo="$part2"
    branch="$part3"
  elif [[ -n "$part2" ]]; then
    if [[ "$part1" =~ ^(https?|file):// || "$part1" =~ ^git@ ]]; then
      slug="$(basename "$part1" .git)"
      repo="$part1"
      branch="$part2"
    else
      slug="$part1"
      repo="$part2"
    fi
  else
    slug="$part1"
    profile_file=$(find "$PROFILES_DIR" -name "$slug.json" -print -quit 2>/dev/null || true)
    if [[ -z "$profile_file" && -d "$SCRIPT_DIR/../vendor_profiles" ]]; then
      profile_file=$(find "$SCRIPT_DIR/../vendor_profiles" -name "$slug.json" -print -quit 2>/dev/null || true)
    fi
    if [[ -n "$profile_file" ]]; then
      repo=$(jq -r '.url // empty' "$profile_file" 2>/dev/null)
      branch=$(jq -r '.branch // empty' "$profile_file" 2>/dev/null)
      tag=$(jq -r '.tag // empty' "$profile_file" 2>/dev/null)
    fi
  fi

  if [[ -n "$repo" ]]; then
    REPOS[$slug]="$repo"
    BRANCHES[$slug]="$branch"
    TAGS[$slug]="$tag"
    ref="${branch:-$tag}"
    sanitized=${ref//\//_}
    path="vendor/${slug}${ref:+-$sanitized}"
    PATHS[$slug]="$path"
    KEEP[$slug]=1
  else
    echo "⚠️  Unknown vendor: $slug" >&2
  fi
done

CUSTOM_VENDORS="$ROOT_DIR/custom_vendors.json"
if [ -f "$CUSTOM_VENDORS" ]; then
  while IFS= read -r slug; do
    repo=$(jq -r ".\"$slug\".repo // empty" "$CUSTOM_VENDORS")
    branch=$(jq -r ".\"$slug\".branch // empty" "$CUSTOM_VENDORS")
    tag=$(jq -r ".\"$slug\".tag // empty" "$CUSTOM_VENDORS")
    if [[ -n "$repo" ]]; then
      REPOS[$slug]="$repo"
      BRANCHES[$slug]="$branch"
      TAGS[$slug]="$tag"
      ref="${branch:-$tag}"
      sanitized=${ref//\//_}
      path="vendor/${slug}${ref:+-$sanitized}"
      PATHS[$slug]="$path"
      KEEP[$slug]=1
    fi
  done < <(jq -r 'keys[]' "$CUSTOM_VENDORS" 2>/dev/null)
fi

# merge existing apps.json entries
if [ -f "$ROOT_DIR/apps.json" ]; then
  while IFS= read -r slug; do
    repo=$(jq -r ".\"$slug\".repo // empty" "$ROOT_DIR/apps.json")
    branch=$(jq -r ".\"$slug\".branch // empty" "$ROOT_DIR/apps.json")
    tag=$(jq -r ".\"$slug\".tag // empty" "$ROOT_DIR/apps.json")
    commit=$(jq -r ".\"$slug\".commit // empty" "$ROOT_DIR/apps.json")
    ref="${branch:-$tag}"
    sanitized=${ref//\//_}
    path="vendor/${slug}${ref:+-$sanitized}"
    PATHS[$slug]="$path"
    if [[ -n "${KEEP[$slug]:-}" ]]; then
      REPOS[$slug]="$repo"
      BRANCHES[$slug]="$branch"
      TAGS[$slug]="$tag"
      APP_INFO[$slug]="$(jq -n --arg repo "$repo" --arg branch "$branch" --arg tag "$tag" --arg commit "$commit" '{repo:$repo,branch:$branch,tag:$tag,commit:$commit}')"
    fi
  done < <(jq -r 'keys[]' "$ROOT_DIR/apps.json" 2>/dev/null)
fi

recognized=("${!KEEP[@]}")

changes=false

for slug in "${recognized[@]}"; do
  repo="${REPOS[$slug]}"
  branch="${BRANCHES[$slug]}"
  tag="${TAGS[$slug]}"
  path="${PATHS[$slug]}"
  target="$ROOT_DIR/$path"
  ref="${branch:-$tag}"
  echo "➡️  Processing $slug ($ref)"
  if grep -q "path = $path" "$ROOT_DIR/.gitmodules" 2>/dev/null; then
    if git ls-files "$path" --error-unmatch >/dev/null 2>&1; then
      if ! git submodule update --init "$path"; then
        echo "❌ Failed to update $slug" >&2
        continue
      fi
      updated+=("$slug")
    else
      echo "📁 Submodule $path not registered in index – re-adding $slug"
      git submodule add -f "$repo" "$path"
      installed+=("$slug")
      changes=true
    fi
  else
    if git submodule add -f "$repo" "$path"; then
      changes=true
      installed+=("$slug")
    else
      echo "❌ Failed to clone $slug from $repo" >&2
      git config --remove-section "submodule.$path" 2>/dev/null || true
      rm -rf "$target"
      continue
    fi
  fi
  if [ ! -d "$target" ]; then
    echo "⚠️  Missing directory for $slug" >&2
    continue
  fi
  pushd "$target" >/dev/null
  if [[ -n "$branch" ]]; then
    git fetch origin "$branch" --tags >/dev/null 2>&1 || git fetch --tags >/dev/null 2>&1 || true
    git checkout "$branch" >/dev/null 2>&1 || git checkout "origin/$branch" >/dev/null 2>&1 || true
  elif [[ -n "$tag" ]]; then
    git fetch origin "tag" "$tag" >/dev/null 2>&1 || git fetch --tags >/dev/null 2>&1 || true
    git checkout "tags/$tag" >/dev/null 2>&1 || git checkout "$tag" >/dev/null 2>&1 || true
  fi
  commit=$(git rev-parse HEAD)
  popd >/dev/null
  APP_INFO[$slug]="$(jq -n --arg repo "$repo" --arg branch "$branch" --arg tag "$tag" --arg commit "$commit" '{repo:$repo,branch:$branch,tag:$tag,commit:$commit}')"
  if [ -d "$target/instructions" ]; then
    mkdir -p "$ROOT_DIR/instructions/_$slug"
    rsync -a --delete "$target/instructions/" "$ROOT_DIR/instructions/_$slug/"
  fi
done

recognized_paths=()
for slug in "${recognized[@]}"; do
  recognized_paths+=("${PATHS[$slug]}")
done

if [ -f "$ROOT_DIR/.gitmodules" ]; then
  while IFS= read -r path; do
    [[ "$path" == vendor/* ]] || continue
    keep=false
    for rp in "${recognized_paths[@]}"; do
      if [[ "$path" == "$rp" ]]; then
        keep=true
        break
      fi
    done
    if ! $keep; then
      echo "🗑 Removing obsolete submodule $path"
      git submodule deinit -f "$path" 2>/dev/null || true
      if [[ -e "$path" ]]; then
        git rm -f "$path" 2>/dev/null || true
      fi
      rm -rf "$ROOT_DIR/.git/modules/$path" "$ROOT_DIR/$path"
      removed+=("$(basename "$path")")
      changes=true
    fi
  done < <(git config --file "$ROOT_DIR/.gitmodules" --get-regexp path | awk '{print $2}')
fi

for dir in "$VENDOR_DIR"/*; do
  [ -d "$dir" ] || continue
  keep=false
  for rp in "${recognized_paths[@]}"; do
    if [[ "$dir" == "$ROOT_DIR/$rp" ]]; then
      keep=true
      break
    fi
  done
  if ! $keep; then
    echo "🗑 Removing obsolete directory $dir"
    rm -rf "$dir"
    removed+=("$(basename "$dir")")
    changes=true
  fi
done

jq_filter='{}'
for slug in "${recognized[@]}"; do
  jq_filter="$jq_filter | .[\"$slug\"]=${APP_INFO[$slug]}"
done
jq -n "$jq_filter" > "$ROOT_DIR/apps.json"

sources=()

# prepend scenario files if available
if [ -d "instructions/_scenarios" ]; then
  while IFS= read -r f; do
    sources+=("$f")
  done < <(find instructions/_scenarios -type f | sort)
fi

# include full depth of app directory
if [ -d "app" ]; then
  while IFS= read -r d; do
    sources+=("${d}/")
  done < <(find app -type d | sort)
fi

# include full depth of vendor directories
for slug in "${recognized[@]}"; do
  path="${PATHS[$slug]}"
  if [ -d "$path" ]; then
    while IFS= read -r d; do
      sources+=("${d}/")
    done < <(find "$path" -type d | sort)
  fi
done

sources+=("instructions/" "sample_data/")
tmp_sources=$(mktemp)
{
  for src in "${sources[@]}"; do
    printf '%s\n' "$src"
  done
} | jq -R -s 'split("\n")[:-1]' > "$tmp_sources"

tmp_templates=$(mktemp)
if [ -f "$CODEX_JSON" ]; then
  jq -r 'if (.templates|type=="array") then .templates else [] end' "$CODEX_JSON" 2>/dev/null > "$tmp_templates" || echo "[]" > "$tmp_templates"
else
  echo "[]" > "$tmp_templates"
fi

jq -n --slurpfile s "$tmp_sources" --slurpfile t "$tmp_templates" '{"_comment":"Directories indexed by Codex. Adjust paths as needed.","sources":$s[0],"templates":$t[0]}' > "$CODEX_JSON"
rm "$tmp_sources" "$tmp_templates"

summary_parts=()
if [ ${#installed[@]} -gt 0 ]; then
  summary_parts+=("Installed: ${installed[*]}")
fi
if [ ${#updated[@]} -gt 0 ]; then
  summary_parts+=("Updated: ${updated[*]}")
fi
if [ ${#removed[@]} -gt 0 ]; then
  summary_parts+=("Removed: ${removed[*]}")
fi
if [ ${#recognized[@]} -gt 0 ]; then
  summary_parts+=("Recognized: ${recognized[*]}")
fi
summary="$(IFS=' | '; echo "${summary_parts[*]}")"
echo "$summary"
