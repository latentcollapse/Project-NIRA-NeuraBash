#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TESTS_DIR="$ROOT_DIR/tests"
pass=0; fail=0
run_one(){ local label="$1"; shift; echo "RUN  $label"; if "$@"; then echo "PASS $label"; ((pass+=1)); else echo "FAIL $label" >&2; ((fail+=1)); fi; }
run_one token-collision "$TESTS_DIR/token-collision/collision_corpus.sh"
run_one static-integrity "$TESTS_DIR/static/no_fake_completion.sh"
if [[ -x "$ROOT_DIR/build/bin/neurabash" ]]; then
  run_one native-jul-mvp env NEURABASH_BIN="$ROOT_DIR/build/bin/neurabash" "$TESTS_DIR/mixed-pipeline/native_jul_mvp.sh"
else
  echo "FAIL built NeuraBash binary not found" >&2; ((fail+=1))
fi
if command -v julia >/dev/null 2>&1; then
  shopt -s nullglob; julia_tests=("$TESTS_DIR"/p0_fixtures/*.jl); shopt -u nullglob
  for t in "${julia_tests[@]}"; do run_one "p0/$(basename "$t")" julia --project="$ROOT_DIR/julia" "$t"; done
else
  echo "FAIL Julia executable not found" >&2; ((fail+=1))
fi
printf '\n=== summary ===\nPASS=%d FAIL=%d\n' "$pass" "$fail"
(( fail == 0 ))
