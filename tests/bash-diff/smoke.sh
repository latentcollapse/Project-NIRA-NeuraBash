#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
UP="${UPSTREAM_BASH_BIN:-$ROOT/build/upstream/bin/bash}"
NB="${NEURABASH_BIN:-$ROOT/build/bin/neurabash}"
[[ -x "$UP" && -x "$NB" ]] || { echo "missing upstream or NeuraBash binary" >&2; exit 2; }

pass=0; fail=0
cases=(
  'printf "%s\n" hello'
  'f(){ printf "%s:%s" "$1" "$2"; }; f alpha beta'
  '(x=inner; printf "%s" "$x")'
  'x=$(printf abc); printf "<%s>" "$x"'
  'read -r x < <(printf "proc\n"); printf "%s" "$x"'
  'a=(zero one two); printf "%s/%s" "${a[1]}" "${#a[@]}"'
  'declare -A a=([x]=1 [y]=2); printf "%s" "$((a[x]+a[y]))"'
  'printf "%s" "$((2 + 3 * 4))"'
  '[[ "abc123" =~ ^abc[0-9]+$ ]] && printf yes'
  'case foobar in foo*) printf hit;; *) printf miss;; esac'
  'for i in 1 2 3; do printf "%s" "$i"; done'
  'i=0; while (( i < 3 )); do ((++i)); done; printf "%s" "$i"'
  'cat <<EOF
hello heredoc
EOF'
  'set -o pipefail; { printf x; exit 0; } | cat'
  'printf "a\nb\n" | while read -r x; do printf "[%s]" "$x"; done'
  'x="a b *"; printf "%q" "$x"'
  'false || printf recovered'
  'true && printf continued'
  '! false; printf ":%s" "$?"'
)

for idx in "${!cases[@]}"; do
  src="${cases[$idx]}"
  set +e
  uout="$("$UP" --noprofile --norc -c "$src" 2>"$ROOT/build/diff-u-$idx.err")"; urc=$?
  nout="$("$NB" --noprofile --norc -c "$src" 2>"$ROOT/build/diff-n-$idx.err")"; nrc=$?
  set -e
  uerr="$(cat "$ROOT/build/diff-u-$idx.err")"; nerr="$(cat "$ROOT/build/diff-n-$idx.err")"
  if [[ "$urc" == "$nrc" && "$uout" == "$nout" && "$uerr" == "$nerr" ]]; then
    printf 'PASS bash-diff-%02d\n' "$idx"; ((pass+=1))
  else
    echo "FAIL bash-diff-$idx" >&2
    printf 'source: %q\nupstream: rc=%s out=%q err=%q\nneurabash: rc=%s out=%q err=%q\n' "$src" "$urc" "$uout" "$uerr" "$nrc" "$nout" "$nerr" >&2
    ((fail+=1))
  fi
done
printf '\nBash differential smoke: %d passed, %d failed\n' "$pass" "$fail"
(( fail == 0 ))
