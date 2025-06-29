#!/bin/bash
set -euo pipefail

TEMPLATE_DIR="$(git rev-parse --show-toplevel)/frappe_app_template"
if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Template not found" >&2
  exit 1
fi

APP_NAME=$(basename "$(git rev-parse --show-toplevel)")

for d in instructions/_*; do
  [ -d "$d" ] || continue
  rsync -a --delete "$d/" "$TEMPLATE_DIR/instructions/$(basename "$d")/"
done

mkdir -p "$TEMPLATE_DIR/.incoming/codex_snapshots"
cp codex.json "$TEMPLATE_DIR/.incoming/codex_snapshots/${APP_NAME}.json"

pushd "$TEMPLATE_DIR" >/dev/null
 git config user.name "codex-bot"
 git config user.email "codex-bot@example.com"
 git add instructions .incoming/codex_snapshots/${APP_NAME}.json
 if git diff --cached --quiet; then
   echo "No changes"
 else
   git commit -m "chore(sync): import from ${APP_NAME}"
 fi
popd >/dev/null
