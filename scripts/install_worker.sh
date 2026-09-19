#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT_DIR/build/bin"
cat > "$ROOT_DIR/build/bin/neurabash-jul-worker" <<'WRAP'
#!/usr/bin/env bash
set -euo pipefail
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SELF_DIR/../.." && pwd)"
exec python3 "$ROOT_DIR/scripts/worker_client.py" "$@"
WRAP
chmod +x "$ROOT_DIR/build/bin/neurabash-jul-worker"
