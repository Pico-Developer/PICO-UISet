#!/bin/bash
# scripts/release.sh
# Tag current version and prepare next release branch.
#
# Usage:
#   ./scripts/release.sh           # auto-increment patch
#   ./scripts/release.sh 0.1.0     # explicit next version
#
# What it does:
#   1. Read current version from package.json
#   2. Tag current commit as v{current}
#   3. Create release/v{next} branch
#   4. Bump package.json to {next}
#   5. Push tag and branch
#
# Prerequisites:
#   - jq installed
#   - Clean working tree
#   - On a release/* branch
#   - Run from repository root

set -euo pipefail

PKG_JSON="Packages/com.bytedance.pico.ui/package.json"
if [ ! -f "$PKG_JSON" ]; then
    echo "Error: $PKG_JSON not found. Run from repository root."
    exit 1
fi

# Check clean tree
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Working tree is not clean. Commit or stash changes first."
    exit 1
fi

CURRENT_VERSION=$(jq -r '.version' "$PKG_JSON")
echo "Current version: ${CURRENT_VERSION}"

# Determine next version
if [ -n "${1:-}" ]; then
    NEXT_VERSION="$1"
else
    IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"
    NEXT_VERSION="${major}.${minor}.$((patch + 1))"
fi
echo "Next version:    ${NEXT_VERSION}"

# Confirm
read -p "Proceed? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "Aborted."
    exit 0
fi

# 1. Tag current version
echo "\n[1/4] Tagging v${CURRENT_VERSION}..."
git tag -a "v${CURRENT_VERSION}" -m "Release v${CURRENT_VERSION}"

# 2. Create next release branch
echo "[2/4] Creating branch release/v${NEXT_VERSION}..."
git checkout -b "release/v${NEXT_VERSION}"

# 3. Bump package.json
echo "[3/4] Bumping package.json to ${NEXT_VERSION}..."
jq ".version = \"${NEXT_VERSION}\"" "$PKG_JSON" > "${PKG_JSON}.tmp" \
    && mv "${PKG_JSON}.tmp" "$PKG_JSON"
git add "$PKG_JSON"
git commit -m "chore: bump version to ${NEXT_VERSION}"

# 4. Push
echo "[4/4] Pushing..."
git push origin "v${CURRENT_VERSION}"
git push origin "release/v${NEXT_VERSION}"

echo ""
echo "✓ Release complete"
echo "  Tag:    v${CURRENT_VERSION}"
echo "  Branch: release/v${NEXT_VERSION}"
echo "  package.json: ${NEXT_VERSION}"
