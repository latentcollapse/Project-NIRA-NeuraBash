#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFIX="${PREFIX:-${HOME}/.local}"
if [[ ${1:-} == --prefix ]]; then
  [[ -n ${2:-} ]] || { echo "usage: $0 [--prefix PATH]" >&2; exit 64; }
  PREFIX="$2"
elif [[ $# -gt 0 ]]; then
  echo "usage: $0 [--prefix PATH]" >&2; exit 64
fi
PREFIX="$(python3 -c 'import os,sys; print(os.path.abspath(os.path.expanduser(sys.argv[1])))' "$PREFIX")"
[[ -x "$ROOT/build/bin/neurabash-real" ]] || { echo "ERROR: build first with ./scripts/build.sh" >&2; exit 1; }

LIBROOT="$PREFIX/lib/neurabash"
BINDIR="$PREFIX/bin"
mkdir -p "$LIBROOT" "$BINDIR"
install -m 0755 "$ROOT/build/bin/neurabash-real" "$LIBROOT/neurabash-real"
install -m 0755 "$ROOT/scripts/worker_client.py" "$LIBROOT/worker_client.py"
rm -rf "$LIBROOT/julia"
cp -a "$ROOT/julia" "$LIBROOT/julia"

cat > "$LIBROOT/neurabash-jul-worker" <<WRAP
#!/usr/bin/env bash
set -euo pipefail
export NEURABASH_ROOT="$LIBROOT"
exec python3 "$LIBROOT/worker_client.py" "\$@"
WRAP
chmod 0755 "$LIBROOT/neurabash-jul-worker"

cat > "$BINDIR/neurabash" <<WRAP
#!/usr/bin/env bash
set -e
export NEURABASH_ACTIVE=1
export NEURABASH_SESSION_ID="\${NEURABASH_SESSION_ID:-nb-\$\$-\$RANDOM-\$RANDOM}"
export NEURABASH_ROOT="$LIBROOT"
export PATH="$LIBROOT:\$PATH"
exec "$LIBROOT/neurabash-real" "\$@"
WRAP
chmod 0755 "$BINDIR/neurabash"

cat > "$BINDIR/neurabash-uninstall" <<WRAP
#!/usr/bin/env bash
set -e
rm -f "$BINDIR/neurabash" "$BINDIR/neurabash-uninstall"
rm -rf "$LIBROOT"
WRAP
chmod 0755 "$BINDIR/neurabash-uninstall"

echo "Installed NeuraBash to $PREFIX"
echo "Ensure $BINDIR is on PATH."
