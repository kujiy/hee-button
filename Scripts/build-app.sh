#!/usr/bin/env bash
# Assemble HeeButton.app from the SwiftPM release build.
# SwiftPM cannot embed an Info.plist, so we build the bundle layout by hand.
set -euo pipefail

VERSION="${1:-0.0.0}"
APP="HeeButton.app"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

swift build -c release

BIN_DIR="$(swift build -c release --show-bin-path)"
BIN="$BIN_DIR/hee-button"
BUNDLE="$BIN_DIR/hee-button_hee-button.bundle"

if [[ ! -x "$BIN" ]]; then
    echo "error: executable not found at $BIN" >&2
    exit 1
fi
if [[ ! -d "$BUNDLE" ]]; then
    echo "error: resource bundle not found at $BUNDLE" >&2
    exit 1
fi

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp "$BIN" "$APP/Contents/MacOS/hee-button"
sed "s/__VERSION__/$VERSION/g" Info.plist.template > "$APP/Contents/Info.plist"
printf 'APPL????' > "$APP/Contents/PkgInfo"
cp -R "$BUNDLE" "$APP/Contents/Resources/"

echo "built $APP (version $VERSION)"
