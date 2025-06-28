#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$ROOT_DIR/frappe_app_template"

if [ ! -f "$TEMPLATE_DIR/setup.sh" ]; then
  echo "❌ frappe_app_template submodule not found at $TEMPLATE_DIR" >&2
  exit 1
fi

cp "$TEMPLATE_DIR/setup.sh" "$ROOT_DIR/setup.sh"
chmod +x "$ROOT_DIR/setup.sh"

pushd "$ROOT_DIR" >/dev/null
./setup.sh
popd >/dev/null

rm -f "$ROOT_DIR/setup.sh"
