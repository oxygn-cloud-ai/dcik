#!/usr/bin/env bash
# generate-manifest.sh — DCIK signed manifest generator
# Generates MANIFEST.json with SHA-256 hashes of all distributed files.
#
# Usage:
#   bash .github/scripts/generate-manifest.sh [--write]
#     --write  Write output to MANIFEST.json (instead of stdout)
#
# The manifest covers:
#   - SKILL.md
#   - perspectives/*.md

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VERSION=""
WRITE_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --write) WRITE_MODE=true; shift ;;
    *) echo "ERROR: Unknown argument: $1"; exit 1 ;;
  esac
done

# Determine project root
PROJECT_ROOT="$SCRIPT_DIR"

# Read version from package.json
if [ -f "${PROJECT_ROOT}/package.json" ]; then
  VERSION=$(grep -oE '"version": *"[^"]+"' "${PROJECT_ROOT}/package.json" | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
fi
if [ -z "$VERSION" ]; then
  VERSION="1.0.4"
fi

# Collect files to hash
FILES=""
for f in "SKILL.md"; do
  if [ -f "${PROJECT_ROOT}/${f}" ]; then
    FILES="${FILES} ${f}"
  fi
done
for f in "${PROJECT_ROOT}/perspectives/"*.md; do
  rel="${f#"${PROJECT_ROOT}/"}"
  FILES="${FILES} ${rel}"
done

# Determine which SHA-256 command to use (Linux vs macOS)
if command -v sha256sum &>/dev/null; then
  SHA_CMD="sha256sum"
else
  SHA_CMD="shasum -a 256"
fi

# Build the manifest JSON
MANIFEST='{'
MANIFEST="${MANIFEST}"$'\n  '"\"version\": \"${VERSION}\","
MANIFEST="${MANIFEST}"$'\n  '"\"files\": {"

FIRST=true
for f in $FILES; do
  FP="${PROJECT_ROOT}/${f}"
  if [ -f "$FP" ]; then
    HASH=$($SHA_CMD "$FP" | awk '{print $1}')
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      MANIFEST="${MANIFEST},"
    fi
    MANIFEST="${MANIFEST}"$'\n    '"\"${f}\": \"${HASH}\""
  fi
done

MANIFEST="${MANIFEST}"$'\n  '
MANIFEST="${MANIFEST}}"
MANIFEST="${MANIFEST}"$'\n}'

if [ "$WRITE_MODE" = true ]; then
  echo "$MANIFEST" > "${PROJECT_ROOT}/MANIFEST.json"
  echo "Wrote MANIFEST.json to ${PROJECT_ROOT}/MANIFEST.json"
else
  echo "$MANIFEST"
fi
