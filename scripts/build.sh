#!/usr/bin/env bash
# Strict top-level build. No required phase is silently skipped.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

printf '%s\n' '=== NeuraBash v0.0.7 build ==='
"$SCRIPT_DIR/fetch_vendor.sh"
"$SCRIPT_DIR/build_bash.sh"
"$SCRIPT_DIR/build_julia.sh"

[[ -x "$ROOT_DIR/build/bin/neurabash" ]] || {
  echo "ERROR: build/bin/neurabash missing after build" >&2
  exit 1
}
[[ -f "$ROOT_DIR/julia/Manifest.toml" ]] || {
  echo "ERROR: julia/Manifest.toml missing after build" >&2
  exit 1
}

echo 'Build complete.'
