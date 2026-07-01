#!/usr/bin/env bash
# Update the hee-button Cask in kujiy/homebrew-tap with a new version + sha256,
# then commit and push. Intended to run in CI (see .github/workflows/release.yml).
# Requires GH_TOKEN in the environment (from secrets.GH_TOKEN_HOMEBREW_TAP).
set -euo pipefail

VERSION="$1"
SHA="$2"

: "${GH_TOKEN:?GH_TOKEN must be set (kujiy/homebrew-tap push token)}"

WORK="$(mktemp -d)"
TAP_DIR="$WORK/homebrew-tap"
git clone "https://x-access-token:${GH_TOKEN}@github.com/kujiy/homebrew-tap.git" "$TAP_DIR"

CASK="$TAP_DIR/Casks/hee-button.rb"
if [[ ! -f "$CASK" ]]; then
    echo "error: $CASK not found in tap" >&2
    exit 1
fi

sed -i '' -E "s/version \".*\"/version \"$VERSION\"/" "$CASK"
sed -i '' -E "s/sha256 \".*\"/sha256 \"$SHA\"/" "$CASK"

git -C "$TAP_DIR" config user.name "github-actions[bot]"
git -C "$TAP_DIR" config user.email "github-actions[bot]@users.noreply.github.com"
git -C "$TAP_DIR" commit -am "hee-button $VERSION"
git -C "$TAP_DIR" push

echo "updated Cask to $VERSION ($SHA)"
