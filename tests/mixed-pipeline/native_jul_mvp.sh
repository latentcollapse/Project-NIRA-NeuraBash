#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NB="${NEURABASH_BIN:-$ROOT/build/bin/neurabash}"
[[ -x "$NB" ]]||exit 2
pass=0; fail=0
check_eq(){ local name="$1" expected="$2"; shift 2; local out rc; set +e; out="$("$@" 2>"$ROOT/build/$name.err")"; rc=$?; set -e; if [[ $rc -eq 0 && "$out" == "$expected" ]]; then echo "PASS $name"; ((pass+=1)); else echo "FAIL $name rc=$rc expected=$expected got=$out" >&2; cat "$ROOT/build/$name.err" >&2||true; ((fail+=1)); fi; }
check_eq bash_only hello "$NB" --noprofile --norc -c 'printf hello'
check_eq ordinary_pipe HELLO "$NB" --noprofile --norc -c 'printf hello | tr a-z A-Z'
check_eq root_math 512 "$NB" --noprofile --norc -c '|!> math.eval "2^3^2"'
check_eq root_unary_pow -4 "$NB" --noprofile --norc -c '|!> math.eval "-2^2"'
check_eq matrix_rank 2 "$NB" --noprofile --norc -c "printf '1,2\n3,4\n' |!> matrix.read |!> matrix.rank"
check_eq matrix_rank_singular 1 "$NB" --noprofile --norc -c "printf '1,2\n2,4\n' |!> matrix.read |!> matrix.rank"
check_eq jul_to_bash RANK=2 "$NB" --noprofile --norc -c "printf '1,2\n3,4\n' |!> matrix.read |!> matrix.rank | sed 's/^/RANK=/'"
check_eq pipestatus '1 0' "$NB" --noprofile --norc -c 'set +e; false |!> text.decode >/dev/null; s=("${PIPESTATUS[@]}"); printf "%s %s" "${s[0]}" "${s[1]}"'
check_eq pipefail 1 "$NB" --noprofile --norc -c 'set +e; set -o pipefail; false |!> text.decode >/dev/null; printf "%s" "$?"'
set +e; out="$($NB --noprofile --norc -c '|!> math.eval "1 == 2" |!> shell.require')"; rc=$?; set -e
[[ $rc -eq 1 && "$out" == false ]]&&{ echo PASS shell_require_false; ((pass+=1)); }||{ echo FAIL shell_require_false >&2; ((fail+=1)); }
check_eq opaque_source '$HOME *.jl' "$NB" --noprofile --norc -c "printf '%s' '\$HOME *.jl' |!> text.decode"
check_eq persistent_binding 2 "$NB" --noprofile --norc -c "printf '1,2\\n3,4\\n' |!> matrix.read |!> core.bind A >/dev/null; |!> @A |!> matrix.rank"
check_eq persistent_tool 3.0 "$NB" --noprofile --norc -c "printf '2,0\\n0,3\\n' |!> matrix.read |!> core.bind A >/dev/null; |!> tool.define spectral_radius @{ matrix.eig --values-only |!> vector.abs |!> vector.max } >/dev/null; |!> @A |!> spectral_radius"

# Bash control operators remain Bash-owned around mixed pipelines.
check_eq bang_negation false "$NB" --noprofile --norc -c '! |!> math.eval "1 == 2" |!> shell.require'
check_eq time_reserved 9 "$NB" --noprofile --norc -c 'time |!> math.eval "3^2"'
check_eq redirection_boundary 5 "$NB" --noprofile --norc -c 'f=$(mktemp); |!> math.eval "2+3" >"$f"; cat "$f"; rm -f "$f"'
check_eq background_wait 7 "$NB" --noprofile --norc -c 'f=$(mktemp); |!> math.eval "3+4" >"$f" & p=$!; wait "$p"; cat "$f"; rm -f "$f"'
check_eq coproc_pipeline 5 "$NB" --noprofile --norc -c 'coproc NB { |!> math.eval "2+3"; }; IFS= read -r x <&"${NB[0]}"; wait "$NB_PID"; printf "%s" "$x"'
check_eq multiple_jul_islands RANK=2 "$NB" --noprofile --norc -c "printf '1,2\\n3,4\\n' |!> matrix.read |!> matrix.rank | sed 's/^/RANK=/' |!> text.decode"

# errexit observes the final mixed-pipeline status when pipefail makes upstream
# Bash failure significant.
set +e
out="$($NB --noprofile --norc -c 'set -e -o pipefail; false |!> text.decode >/dev/null; printf SHOULD_NOT_RUN' 2>"$ROOT/build/errexit.err")"
rc=$?
set -e
if [[ $rc -eq 1 && -z "$out" ]]; then
  echo 'PASS errexit_pipefail'; ((pass+=1))
else
  echo "FAIL errexit_pipefail: rc=$rc out=$out" >&2; cat "$ROOT/build/errexit.err" >&2 || true; ((fail+=1))
fi

# A downstream close must look like an ordinary Unix producer SIGPIPE.  We
# write enough output to make the pipe close before the worker finishes.
set +e
$NB --noprofile --norc -c '|!> math.eval "[1,2,3,4,5]" |!> render.text | head -n0; s=("${PIPESTATUS[@]}"); printf "%s" "${s[0]}"' >"$ROOT/build/sigpipe.out" 2>"$ROOT/build/sigpipe.err"
rc=$?
set -e
sigout="$(cat "$ROOT/build/sigpipe.out")"
if [[ $rc -eq 0 && "$sigout" == 141 ]]; then
  echo 'PASS sigpipe_status'; ((pass+=1))
else
  echo "FAIL sigpipe_status: command_rc=$rc worker_status=$sigout" >&2; cat "$ROOT/build/sigpipe.err" >&2 || true; ((fail+=1))
fi

printf '\nNative JUL MVP: %d passed, %d failed\n' "$pass" "$fail"; ((fail==0))
