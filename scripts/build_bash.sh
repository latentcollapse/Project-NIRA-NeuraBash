#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VENDOR_DIR="$ROOT_DIR/vendor/bash"
BUILD_DIR="$ROOT_DIR/build"
PATCH_DIR="$ROOT_DIR/src/bash_patch"
[[ -f "$VENDOR_DIR/.fetch_complete" ]] || { echo "ERROR: run fetch_vendor.sh" >&2; exit 1; }
shopt -s nullglob
patches=("$PATCH_DIR"/*.patch)
shopt -u nullglob
(( ${#patches[@]} > 0 )) || { echo "ERROR: no native NeuraBash Bash patchset" >&2; exit 1; }
mkdir -p "$BUILD_DIR"
cd "$VENDOR_DIR"
./configure --prefix="$BUILD_DIR/upstream" CFLAGS="-O2"
make -j"$(nproc)"
make install
make distclean
for patchfile in "${patches[@]}"; do patch --forward -p1 < "$patchfile"; done
./configure --prefix="$BUILD_DIR" CFLAGS="-O2 -Wall -Wextra"
make -j"$(nproc)"
make install
mv "$BUILD_DIR/bin/bash" "$BUILD_DIR/bin/neurabash-real"
cat > "$BUILD_DIR/bin/neurabash" <<'EOF'
#!/usr/bin/env bash
set -e
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
export NEURABASH_ACTIVE=1
export PATH="$SELF_DIR:$PATH"
exec "$SELF_DIR/neurabash-real" "$@"
EOF
chmod +x "$BUILD_DIR/bin/neurabash"
"$SCRIPT_DIR/install_worker.sh"
"$BUILD_DIR/bin/neurabash" -c 'test "${NEURABASH_ACTIVE:-}" = 1'
