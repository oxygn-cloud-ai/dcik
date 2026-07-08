#!/usr/bin/env bash
# sync-all.sh -- bump the version and/or regenerate all derived artifacts.
#
# THE ONLY SUPPORTED WAY TO CHANGE THE DCIK VERSION. Never hand-edit version
# strings: DCIK declares its version in many files (package.json, SKILL.md,
# both .claude-plugin manifests, ARCHITECTURE.md) and mirrors everything under
# desktop/. A partial hand-edit silently ships an inconsistent version in the
# plugin manifests that `/plugin install` reads. This script moves every
# location atomically and then HARD-FAILS if any stray version remains.
#
# Usage:
#   bash scripts/sync-all.sh              # re-sync derived artifacts at current version
#   bash scripts/sync-all.sh 1.0.9        # bump every location to 1.0.9, then sync
#   bash scripts/sync-all.sh --version 1.0.9
#   bash scripts/sync-all.sh --check      # read-only: verify version consistency, mutate nothing (used by CI)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Read the canonical version from package.json (fallback SKILL.md frontmatter).
read_version() {
  local v
  v=$(grep -oE '"version": *"[^"]+"' package.json | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  [ -z "$v" ] && v=$(grep -oE 'version: [0-9]+\.[0-9]+\.[0-9]+' SKILL.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  printf '%s' "$v"
}

# HARD version-consistency gate — every X.Y.Z semver in tracked *.json / *.md
# (outside perspectives/ and the changelog) must equal the canonical version.
# This is the guard that makes a partial bump impossible. CHANGELOG.md is
# excluded because it legitimately records every historical version.
# Returns non-zero on any disagreement.
enforce_consistency() {
  local version="$1" stray
  # eval/ is a research log: its result files legitimately reference the historical version that
  # produced each experiment (like CHANGELOG), so it is excluded from the single-version gate.
  local scope=(-- '*.json' '*.md' ':!perspectives/**' ':!desktop/perspectives/**' ':!CHANGELOG.md' ':!eval/**')
  stray=$(git grep -hoE '[0-9]+\.[0-9]+\.[0-9]+' "${scope[@]}" \
    | sort -u | grep -vxE "$(printf '%s' "$version" | sed 's/\./\\./g')" || true)
  if [ -n "$stray" ]; then
    echo "ERROR: version(s) other than $version found in tracked files:" >&2
    printf '%s\n' "$stray" | sed 's/^/  - /' >&2
    echo "Offending files:" >&2
    git grep -nE "($(printf '%s' "$stray" | paste -sd'|' -))" "${scope[@]}" \
      | sed 's/^/  /' >&2
    echo "Fix by re-running: bash scripts/sync-all.sh $version" >&2
    return 1
  fi
  return 0
}

# --check: read-only CI gate. Verify consistency and exit without mutating anything.
if [ "${1:-}" = "--check" ]; then
  V=$(read_version)
  echo "=== DCIK version-consistency check (v$V) ==="
  if enforce_consistency "$V"; then
    echo "All version declarations == $V ✓"
    exit 0
  fi
  exit 1
fi

echo "=== DCIK sync-all ==="

# Parse optional target version
NEW_VERSION=""
case "${1:-}" in
  --version) NEW_VERSION="${2:-}" ;;
  "" ) : ;;
  * ) NEW_VERSION="$1" ;;
esac
if [ -n "$NEW_VERSION" ] && ! printf '%s' "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "ERROR: version must be X.Y.Z (got '$NEW_VERSION')" >&2
  exit 1
fi

# 0a. Bump source-of-truth version files (only if a target version was given)
if [ -n "$NEW_VERSION" ]; then
  echo "[0/7] Bumping all source-of-truth files → $NEW_VERSION"
  # JSON "version": "X.Y.Z"  (package.json: 1 field, marketplace.json: 2 fields, plugin.json: 1 field)
  for f in package.json .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
    sed -i '' -E "s/\"version\": *\"[0-9]+\.[0-9]+\.[0-9]+\"/\"version\": \"$NEW_VERSION\"/g" "$f"
  done
  # SKILL.md frontmatter:  version: X.Y.Z
  sed -i '' -E "s/^version: [0-9]+\.[0-9]+\.[0-9]+/version: $NEW_VERSION/" SKILL.md
  # Additional skills under skills/*/SKILL.md carry the same plugin version (consistency gate).
  for s in skills/*/SKILL.md; do
    [ -f "$s" ] && sed -i '' -E "s/^version: [0-9]+\.[0-9]+\.[0-9]+/version: $NEW_VERSION/" "$s"
  done
  # ARCHITECTURE.md inline example:  `version: X.Y.Z`
  sed -i '' -E "s/version: [0-9]+\.[0-9]+\.[0-9]+/version: $NEW_VERSION/g" ARCHITECTURE.md
else
  echo "[0/7] No version argument — re-syncing at current version."
fi

# 0b. Read the (now canonical) version
VERSION=$(grep -oE '"version": *"[^"]+"' package.json | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
if [ -z "$VERSION" ]; then
  VERSION=$(grep -oE 'version: [0-9]+\.[0-9]+\.[0-9]+' SKILL.md | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
fi
echo "       Canonical version: $VERSION"

# 1. Sync desktop mirror (propagates SKILL.md, docs, perspectives, plugin manifests)
echo "[1/7] Syncing desktop mirror..."
for f in SKILL.md README.md PHILOSOPHY.md ARCHITECTURE.md; do
  cp "$f" "desktop/$f"
done
cp -r perspectives/ desktop/perspectives/
cp -r .claude-plugin/. desktop/.claude-plugin/ 2>/dev/null || true
echo "       Desktop mirror + plugin config synced."

# 2. Sync version into README badge lines (vX.Y.Z)
echo "[2/7] Syncing version into README files..."
sed -i '' -E "s/v[0-9]+\.[0-9]+\.[0-9]+/v$VERSION/g" README.md
sed -i '' -E "s/v[0-9]+\.[0-9]+\.[0-9]+/v$VERSION/g" desktop/README.md
echo "       README version → v$VERSION"

# 3. Regenerate MANIFEST.json (SKILL.md hash changes when version changes)
echo "[3/7] Regenerating MANIFEST.json..."
bash .github/scripts/generate-manifest.sh > MANIFEST.json
cp MANIFEST.json desktop/manifest.json
echo "       MANIFEST.json regenerated (+ desktop/manifest.json)."

# 4. Rebuild SKILL.zip
echo "[4/7] Rebuilding SKILL.zip..."
rm -f SKILL.zip
zip -rq SKILL.zip SKILL.md perspectives/ LICENSE
ZIP_COUNT=$(unzip -l SKILL.zip | grep -c '\.md$' || echo 0)
echo "       SKILL.zip rebuilt ($ZIP_COUNT .md files)."

# 5. Sync installed skill
echo "[5/7] Syncing installed skill..."
SKILL_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK"
if [ -d "$SKILL_DIR" ]; then
  cp SKILL.md "$SKILL_DIR/"
  cp MANIFEST.json "$SKILL_DIR/"
  rm -rf "$SKILL_DIR/perspectives"
  cp -r perspectives/ "$SKILL_DIR/perspectives/"
  echo "       Installed skill synced to $SKILL_DIR."
else
  echo "       Skill not installed at $SKILL_DIR — skipping."
fi

# 6. Verify integrity (MANIFEST hash + perspective counts)
echo "[6/7] Verifying integrity..."
MANIFEST_HASH=$(grep -o '"SKILL.md": "[^"]*"' MANIFEST.json | grep -oE '[a-f0-9]{64}')
ACTUAL_HASH=$(shasum -a 256 SKILL.md | awk '{print $1}')
if [ "$MANIFEST_HASH" != "$ACTUAL_HASH" ]; then
  echo "       ERROR: MANIFEST hash mismatch for SKILL.md." >&2
  exit 1
fi
echo "       MANIFEST hash matches. ✓"
ROOT_COUNT=$(ls perspectives/*.md | wc -l | tr -d ' ')
DESK_COUNT=$(ls desktop/perspectives/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$ROOT_COUNT" != "$DESK_COUNT" ]; then
  echo "       ERROR: perspective count mismatch (root=$ROOT_COUNT desktop=$DESK_COUNT)." >&2
  exit 1
fi
echo "       Perspectives: root=$ROOT_COUNT desktop=$DESK_COUNT ✓"

# 7. HARD version-consistency gate — fail loudly if ANY version disagrees.
# This is the guard that makes a partial bump impossible: every X.Y.Z semver in
# tracked *.json / *.md (outside perspectives/) must equal the canonical version.
echo "[7/7] Enforcing version consistency..."
if ! enforce_consistency "$VERSION"; then
  exit 1
fi
echo "       All version declarations == $VERSION ✓"

echo ""
echo "=== Done: DCIK synced at v$VERSION ==="
