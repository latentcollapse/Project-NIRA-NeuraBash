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
printf '\nNative JUL MVP: %d passed, %d failed\n' "$pass" "$fail"; ((fail==0))
