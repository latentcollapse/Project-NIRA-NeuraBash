#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
JULIA_DIR="$ROOT_DIR/julia"
command -v julia >/dev/null || { echo "ERROR: Julia not found" >&2; exit 1; }
cd "$JULIA_DIR"
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile(); using NeuraBash; println("NeuraBash Julia module loaded")'
