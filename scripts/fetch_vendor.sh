#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VENDOR_DIR="$ROOT_DIR/vendor/bash"
VENDOR_HASH_FILE="$ROOT_DIR/VENDOR_HASH"
source "$VENDOR_HASH_FILE"
mkdir -p "$VENDOR_DIR"
if [[ -f "$VENDOR_DIR/.fetch_complete" ]]; then exit 0; fi
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT
ARCHIVE="$TEMP_DIR/bash-$BASH_VERSION.tar.gz"
urls=(
  "$BASH_URL"
  "https://ftp.osuosl.org/pub/gnu/bash/bash-$BASH_VERSION.tar.gz"
  "https://ftp.csc.fi/pub/gnu/ftp.gnu.org/gnu/bash/bash-$BASH_VERSION.tar.gz"
)
downloaded=0
for url in "${urls[@]}"; do
  echo "trying $url"
  if curl --fail --location --retry 3 --retry-delay 2 -o "$ARCHIVE" "$url"; then downloaded=1; break; fi
done
(( downloaded == 1 )) || { echo "ERROR: unable to download pinned Bash source" >&2; exit 1; }
ACTUAL_SHA=$(sha256sum "$ARCHIVE" | cut -d' ' -f1)
[[ "$ACTUAL_SHA" == "$BASH_SHA256" ]] || { echo "ERROR: SHA256 mismatch: $ACTUAL_SHA" >&2; exit 1; }
tar -xzf "$ARCHIVE" -C "$TEMP_DIR"
rm -rf "$VENDOR_DIR"/*
mv "$TEMP_DIR/bash-$BASH_VERSION"/* "$VENDOR_DIR/"
touch "$VENDOR_DIR/.fetch_complete"
