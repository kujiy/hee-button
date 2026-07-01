#!/usr/bin/env bash
# Assemble HeeButton.app from the SwiftPM release build.
# SwiftPM cannot embed an Info.plist, so we build the bundle layout by hand.
# Resources are copied straight into Contents/Resources and loaded via
# Bundle.main (see Package.swift for why we avoid Bundle.module).
set -euo pipefail

VERSION="${1:-0.0.0}"
APP="HeeButton.app"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

swift build -c release

BIN_DIR="$(swift build -c release --show-bin-path)"
BIN="$BIN_DIR/hee-button"

if [[ ! -x "$BIN" ]]; then
    echo "error: executable not found at $BIN" >&2
    exit 1
fi

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp "$BIN" "$APP/Contents/MacOS/hee-button"
sed "s/__VERSION__/$VERSION/g" Info.plist.template > "$APP/Contents/Info.plist"
printf 'APPL????' > "$APP/Contents/PkgInfo"

# App resources (menu-bar icons + sound), loaded via Bundle.main.
# Only the icons the app actually uses — not README assets like hero.png.
for icon in button he-simple hee-simple-blue; do
    cp "Sources/hee-button/Resources/$icon.png" "$APP/Contents/Resources/"
    cp "Sources/hee-button/Resources/$icon@2x.png" "$APP/Contents/Resources/"
done
cp Sources/hee-button/Resources/he-.mp3 "$APP/Contents/Resources/"
# Finder / bundle icon.
cp packaging/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

# Ad-hoc sign so the bundle is self-consistent and launches on Apple Silicon
# once quarantine is removed (the Cask strips quarantine on install).
codesign --force --deep --sign - "$APP"

echo "built $APP (version $VERSION)"
