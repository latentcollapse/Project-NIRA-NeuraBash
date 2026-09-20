#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fail=0
check_absent(){ local p="$1"; shift; if grep -RInE "$p" "$@" >/tmp/nbgrep 2>/dev/null; then cat /tmp/nbgrep >&2; fail=1; fi; }
check_absent 'using Serialization|import Serialization' "$ROOT/julia/src"
check_absent 'Symlink:.*neurabash.*-> bash' "$ROOT/scripts"
exit "$fail"
