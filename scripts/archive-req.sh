#!/bin/bash
# scripts/archive-req.sh
# Semi-automated requirement archival script.
#
# Usage:
#   ./scripts/archive-req.sh REQ-001_slider
#
# What it does:
#   1. Reads current version from package.json
#   2. Moves the requirement directory to archive/v{version}/
#   3. Creates a git commit
#
# Prerequisites:
#   - jq installed
#   - Clean working tree (no uncommitted changes)
#   - Run from repository root

set -euo pipefail

REQ_ID="${1:?Usage: $0 <REQ_ID> (e.g. REQ-001_slider)}"

# Locate package.json
PKG_JSON="Packages/com.bytedance.pico.ui/package.json"
if [ ! -f "$PKG_JSON" ]; then
    echo "Error: $PKG_JSON not found. Run from repository root."
    exit 1
fi

VERSION=$(jq -r '.version' "$PKG_JSON")
SRC=".spec-coding/requirements/${REQ_ID}"
DST=".spec-coding/archive/v${VERSION}/${REQ_ID}"

# Validate source exists
if [ ! -d "$SRC" ]; then
    echo "Error: $SRC not found."
    echo "Available requirements:"
    ls -1 .spec-coding/requirements/ | grep '^REQ-' || echo "  (none)"
    exit 1
fi

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Working tree is not clean. Commit or stash changes first."
    exit 1
fi

# Execute archival
mkdir -p "$(dirname "$DST")"
git mv "$SRC" "$DST"
git commit -m "chore(spec-coding): archive ${REQ_ID} to v${VERSION}"

echo "✓ Archived: ${REQ_ID}"
echo "  From: ${SRC}"
echo "  To:   ${DST}"
echo ""
echo "Don't forget to push or include in your next MR."
