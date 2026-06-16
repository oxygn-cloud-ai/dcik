#!/usr/bin/env bash
# sync-all.sh -- regenerate all derived artifacts after source changes
# Run this after any change to SKILL.md, README.md, PHILOSOPHY.md,
# ARCHITECTURE.md, or perspective files.
#
# Usage: bash scripts/sync-all.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== DCIK sync-all ==="

# 1. Sync desktop mirror
echo "[1/6] Syncing desktop mirror..."
for f in SKILL.md README.md PHILOSOPHY.md ARCHITECTURE.md; do
  cp "$f" "desktop/$f"
done
cp -r perspectives/ desktop/perspectives/
echo "       Desktop mirror synced."

# 2. Update pinned hash in SKILL.md
echo "[2/6] Updating pinned integrity hash..."
SKILL_HASH=$(shasum -a 256 SKILL.md | awk '{print $1}')
CURRENT_PINNED=$(grep -oE '`[a-f0-9]{64}`' SKILL.md | head -1 | tr -d '`')
if [ -n "$CURRENT_PINNED" ] && [ "$CURRENT_PINNED" != "$SKILL_HASH" ]; then
  sed -i '' "s/$CURRENT_PINNED/$SKILL_HASH/" SKILL.md
  sed -i '' "s/$CURRENT_PINNED/$SKILL_HASH/" desktop/SKILL.md 2>/dev/null || true
  echo "       Pinned hash updated: $CURRENT_PINNED → $SKILL_HASH"
else
  echo "       Pinned hash already current."
fi

# 3. Regenerate MANIFEST.json (after hash update since it changes SKILL.md)
echo "[3/6] Regenerating MANIFEST.json..."
bash .github/scripts/generate-manifest.sh > MANIFEST.json
echo "       MANIFEST.json regenerated."

# 4. Rebuild SKILL.zip
echo "[4/6] Rebuilding SKILL.zip..."
rm -f SKILL.zip
zip -rq SKILL.zip SKILL.md perspectives/ LICENSE
ZIP_COUNT=$(unzip -l SKILL.zip | grep -c '\.md$' || echo 0)
echo "       SKILL.zip rebuilt ($ZIP_COUNT .md files)."

# 5. Sync installed skill
echo "[5/6] Syncing installed skill..."
SKILL_DIR="$HOME/.claude/skills/DCIK"
if [ -d "$SKILL_DIR" ]; then
  cp SKILL.md "$SKILL_DIR/"
  rm -rf "$SKILL_DIR/perspectives"
  cp -r perspectives/ "$SKILL_DIR/perspectives/"
  echo "       Installed skill synced to $SKILL_DIR."
else
  echo "       Skill not installed at $SKILL_DIR — skipping."
fi

# 6. Verify
echo "[6/6] Verifying..."
MANIFEST_HASH=$(grep -o '"SKILL.md": "[^"]*"' MANIFEST.json | grep -oE '[a-f0-9]{64}')
ACTUAL_HASH=$(shasum -a 256 SKILL.md | awk '{print $1}')
if [ "$MANIFEST_HASH" = "$ACTUAL_HASH" ]; then
  echo "       MANIFEST hash matches. ✓"
else
  echo "       WARNING: MANIFEST hash mismatch. Regenerate with: bash .github/scripts/generate-manifest.sh > MANIFEST.json"
fi

ROOT_COUNT=$(ls perspectives/*.md | wc -l | tr -d ' ')
DESK_COUNT=$(ls desktop/perspectives/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "       Perspectives: root=$ROOT_COUNT desktop=$DESK_COUNT"

echo ""
echo "=== Done ==="
