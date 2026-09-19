#!/usr/bin/env bash
set -euo pipefail
BASH_BIN="${UPSTREAM_BASH_BIN:-bash}"
PINNED_VERSION="5.2.37"
actual="$($BASH_BIN --version | head -n1)"
[[ "$actual" == *"version ${PINNED_VERSION}"* ]] || { echo "ERROR: need GNU Bash $PINNED_VERSION" >&2; exit 2; }
pass=0; fail=0; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
run_reject_case(){
 local name="$1" source="$2" stdout="$tmp/$name.out" stderr="$tmp/$name.err" marker="$tmp/$name.marker" rc
 set +e; NB_MARKER="$marker" "$BASH_BIN" --noprofile --norc -c "$source" >"$stdout" 2>"$stderr"; rc=$?; set -e
 local ok=1
 ((rc!=0))||ok=0; [[ ! -s "$stdout" ]]||ok=0
 [[ -s "$stderr" ]]&&grep -qiE 'syntax error|unexpected token' "$stderr"||ok=0
 [[ ! -e "$marker" ]]||ok=0
 if ((ok)); then printf 'PASS %-30s rc=%d\n' "$name" "$rc"; ((pass+=1)); else echo "FAIL $name" >&2; cat "$stderr" >&2||true; ((fail+=1)); fi
}
run_reject_case basic 'echo x |!> "$NB_MARKER"'
run_reject_case fd_adjacency 'echo x |!>&1; : > "$NB_MARKER"'
run_reject_case word_adjacency 'echo x |!>out; : > "$NB_MARKER"'
run_reject_case spaced_bang_gt 'echo x | !> "$NB_MARKER"'
run_reject_case spaced_all 'echo x | ! > "$NB_MARKER"'
run_reject_case spaced_after_bang 'echo x |! > "$NB_MARKER"'
run_reject_case function_ctx 'f(){ echo x |!> y; }; f; : > "$NB_MARKER"'
run_reject_case subshell_ctx '(echo x |!> y); : > "$NB_MARKER"'
run_reject_case brace_ctx '{ echo x |!> y; }; : > "$NB_MARKER"'
run_reject_case cmdsubst_ctx 'v=$(echo x |!> y); : > "$NB_MARKER"'
run_reject_case process_subst_ctx 'cat <(echo x |!> y); : > "$NB_MARKER"'
run_reject_case time_ctx 'time echo x |!> y; : > "$NB_MARKER"'
run_reject_case bang_ctx '! echo x |!> y; : > "$NB_MARKER"'
run_reject_case coproc_ctx 'coproc X { echo x |!> y; }; : > "$NB_MARKER"'
run_reject_case and_ctx 'true && echo x |!> y; : > "$NB_MARKER"'
run_reject_case or_ctx 'false || echo x |!> y; : > "$NB_MARKER"'
run_reject_case background_ctx 'echo x |!> y & wait; : > "$NB_MARKER"'
printf '\nToken collision: %d passed, %d failed\n' "$pass" "$fail"; ((fail==0))
