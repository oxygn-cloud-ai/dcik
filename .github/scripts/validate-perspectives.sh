#!/usr/bin/env bash
# validate-perspectives.sh -- DCIK content validation
# Checks perspective files for format compliance and injection patterns.
# Exit 0 = clean. Exit 1 = violations found.

set -uo pipefail

VIOLATIONS=0
PERSPECTIVES_DIR="${PERSPECTIVES_DIR:-perspectives}"
CONTRACT_OK=0        # perspectives migrated to Contract v2 (have '## Required output')
CONTRACT_MISSING=0   # not yet migrated — WARN only, does not fail CI (migration ratchet)

# ── Format validation ──────────────────────────────────────────────

check_format() {
  local file="$1"
  local issues=0

  # Required header
  grep -q '^# Perspective:' "$file" || {
    echo "  FORMAT: missing '# Perspective:' header"
    issues=$((issues + 1))
  }

  # Required ID
  grep -qE '^\*\*ID:\*\* P[0-9]+' "$file" || {
    echo "  FORMAT: missing or malformed '**ID:** P##' field"
    issues=$((issues + 1))
  }

  # Domain or Source (at least one must be present)
  grep -qE '^\*\*(Domain|Source):\*\*' "$file" || {
    echo "  FORMAT: missing '**Domain:**' or '**Source:**' field"
    issues=$((issues + 1))
  }

  # Required Invoke when
  grep -qE '^\*\*Invoke when:\*\*' "$file" || {
    echo "  FORMAT: missing '**Invoke when:**' field"
    issues=$((issues + 1))
  }

  # Required Lens section
  grep -q '^## Lens$' "$file" || {
    echo "  FORMAT: missing '## Lens' section"
    issues=$((issues + 1))
  }

  # Required Adversarial stance section
  grep -q '^## Default adversarial stance$' "$file" || {
    echo "  FORMAT: missing '## Default adversarial stance' section"
    issues=$((issues + 1))
  }

  # Lens must have numbered questions (at least 4, at most 12)
  # Compendium perspectives (marked with "**Compendium:** true") are exempt from the 12-max cap
  local lens_count is_compendium
  lens_count=$(sed -n '/## Lens/,/## Default/p' "$file" | grep -cE '^[0-9]+\. ' 2>/dev/null) || lens_count=0
  is_compendium=$(grep -cE '^\*\*Compendium:\*\* true' "$file" 2>/dev/null) || is_compendium=0
  if [ "$lens_count" -lt 4 ]; then
    echo "  FORMAT: Lens has $lens_count questions (minimum 4)"
    issues=$((issues + 1))
  elif [ "$lens_count" -gt 12 ] && [ "$is_compendium" -eq 0 ]; then
    echo "  FORMAT: Lens has $lens_count questions (maximum 12; compendiums exempt)"
    issues=$((issues + 1))
  fi

  # File name must match ID
  local expected_id actual_id
  expected_id=$(echo "$file" | sed -n 's/.*\/P\([0-9]\{1,\}\).*/\1/p')
  actual_id=$(grep -oE '^\*\*ID:\*\* P[0-9]+' "$file" 2>/dev/null | grep -oE '[0-9]+' 2>/dev/null) || actual_id=""
  if [ -n "$expected_id" ] && [ -n "$actual_id" ] && [ "$expected_id" != "$actual_id" ]; then
    echo "  FORMAT: filename P${expected_id} does not match declared ID P${actual_id}"
    issues=$((issues + 1))
  fi

  return $issues
}

# ── Injection detection ────────────────────────────────────────────

check_injection() {
  local file="$1"
  local issues=0

  # Unambiguous prompt injection patterns (case-insensitive, extended regex)
  local patterns=(
    'ignore (all )?(previous |above )?(instructions|directions|context)'
    'disregard (above|previous|all) (instructions|directions)'
    'you are now (a |an |the )'
    'your (new |primary |only )?(instruction|directive|goal|purpose) is'
    '\[system prompt\]'
    '\[system\]'
    '<system>'
    '<instruction>'
    '<prompt>'
    'override (your |all )?(instructions|safety|guidelines)'
    'pretend (you are|to be)'
    'act as (if|though) you are'
    'do not (follow|obey|comply with)'
    'forget (all |everything )?(before|above|prior)'
    '<\|im_start\|>'
    '\[INST\]'
    '\{#system#\}'
    'you must (not |never )?(refuse|decline|reject)'
    'from now on you are'
    'your (true|real) (name|identity|purpose) is'
  )

  for pattern in "${patterns[@]}"; do
    if grep -qinE "$pattern" "$file" 2>/dev/null; then
      echo "  INJECTION: pattern '$pattern' found in $file"
      grep -inE "$pattern" "$file" 2>/dev/null | while read -r line; do
        echo "    $line"
      done
      issues=$((issues + 1))
    fi
  done

  # Unicode homoglyph detection — normalize and re-check
  # Replace common Cyrillic lookalikes with Latin equivalents, then re-scan
  local normalized
  normalized=$(cat "$file" 2>/dev/null \
    | sed 's/[аА]/a/g; s/[еЕ]/e/g; s/[оО]/o/g; s/[рР]/p/g; s/[сС]/c/g; s/[хХ]/x/g; s/[уУ]/y/g')
  if [ "$normalized" != "$(cat "$file" 2>/dev/null)" ]; then
    echo "  INJECTION: Unicode homoglyphs detected in $file (Cyrillic characters that look like Latin)"
    issues=$((issues + 1))
  fi

  # Multi-line injection: check for "ignore" within 50 chars of "instructions"/"directions"
  # across line boundaries (catches split-across-lines injection attempts)
  local collapsed
  collapsed=$(tr '\n' ' ' < "$file" 2>/dev/null | tr -s ' ')
  if echo "$collapsed" | grep -qiE '\bignore\b.{0,50}\b(instructions|directions)\b' 2>/dev/null; then
    if ! grep -qinE 'ignore (all )?(previous |above )?(instructions|directions|context)' "$file" 2>/dev/null; then
      echo "  INJECTION: multi-line 'ignore ... instructions' variant detected in $file"
      issues=$((issues + 1))
    fi
  fi

  # Code blocks in perspective files are not allowed
  if grep -q '```' "$file" 2>/dev/null; then
    echo "  INJECTION: code block (\`\`\`) found in $file -- perspectives must not contain executable blocks"
    issues=$((issues + 1))
  fi

  return $issues
}

# ── SKILL.md change detection ──────────────────────────────────────

check_skill_changes() {
  local changed
  changed=$(git diff --name-only "origin/main..HEAD" 2>/dev/null) || return 0
  if echo "$changed" | grep -qE '^(SKILL\.md|desktop/SKILL\.md)$'; then
    echo "WARNING: SKILL.md modified in this PR -- requires manual review for injection risk."
    echo "::warning::SKILL.md was modified in this PR. Review for prompt injection before merging."
  fi
}

# ── Contract v2 (WARN-only migration ratchet) ─────────────────────
# Checks presence of the '## Required output' section that forces each lens to yield a
# falsifiable deliverable. This is a STRUCTURAL gate only — it cannot judge whether the
# output is good (perspective quality is validated by eval/, not here). It WARNS rather
# than FAILS so the library can migrate incrementally without breaking CI. Flip to a hard
# failure once CONTRACT_MISSING reaches 0 across the library.
check_contract() {
  local file="$1"
  local has_req has_fals body_lines why
  has_req=$(grep -c '^## Required output$' "$file" 2>/dev/null) || has_req=0
  has_fals=$(grep -c '^## Falsifier$' "$file" 2>/dev/null) || has_fals=0
  # non-empty, non-stub content lines inside the '## Required output' section
  body_lines=$(awk '/^## Required output$/{f=1;next} /^## /{f=0} f && NF' "$file" 2>/dev/null \
                 | grep -ivE '^[[:space:]]*(TBD|TODO|XXX|N/?A|\.\.\.)\.?[[:space:]]*$' \
                 | grep -c .) || body_lines=0
  if [ "$has_req" -ge 1 ] && [ "$has_fals" -ge 1 ] && [ "$body_lines" -ge 3 ]; then
    CONTRACT_OK=$((CONTRACT_OK + 1))
  else
    CONTRACT_MISSING=$((CONTRACT_MISSING + 1))
    if [ "$has_req" -lt 1 ]; then why="missing '## Required output'"
    elif [ "$has_fals" -lt 1 ]; then why="missing '## Falsifier'"
    else why="'## Required output' is vacuous (<3 non-stub content lines)"; fi
    echo "  CONTRACT: not migrated to v2 ($why) — WARN only"
    echo "::warning::${file}: Contract v2 not satisfied ($why)."
  fi
}

# ── Main ───────────────────────────────────────────────────────────

echo "=== DCIK Content Validation ==="
echo ""

# Find changed or new perspective files
if [ -n "${GITHUB_EVENT_NAME:-}" ] && [ "${GITHUB_EVENT_NAME:-}" = "pull_request" ]; then
  # Honour PERSPECTIVES_DIR so the desktop step (PERSPECTIVES_DIR=desktop/perspectives)
  # actually inspects desktop/perspectives/ changes. Previously this was hardcoded to
  # '^perspectives/', so the desktop validate step did identical work to the root step
  # and never validated desktop perspectives on PRs.
  PREFIX="${PERSPECTIVES_DIR%/}/"
  echo "Mode: PR validation (changed files under ${PREFIX})"
  CHANGED=$(git diff --name-only "origin/${GITHUB_BASE_REF:-main}..HEAD" 2>/dev/null | grep "^${PREFIX}" 2>/dev/null) || CHANGED=""
else
  echo "Mode: full scan (all perspective files)"
  CHANGED=$(find "$PERSPECTIVES_DIR" -name '*.md' -type f 2>/dev/null | sort) || CHANGED=""
fi

if [ -z "$CHANGED" ]; then
  echo "No perspective files to check."
else
  echo ""
  # Process each file
  while IFS= read -r file; do
    [ -z "$file" ] && continue
    # In PR mode `git diff` lists DELETED/renamed files too. Skip paths that no longer exist,
    # otherwise check_format greps a missing file and false-fails a legitimate deletion.
    [ -f "$file" ] || { echo "--- $file (deleted/renamed — skipped) ---"; continue; }

    echo "--- $file ---"
    local_issues=0

    check_format "$file"
    local_issues=$((local_issues + $?))

    check_injection "$file"
    local_issues=$((local_issues + $?))

    # Contract check is WARN-only: intentionally NOT added to local_issues/VIOLATIONS.
    check_contract "$file"

    if [ "$local_issues" -eq 0 ]; then
      echo "  PASS"
    else
      echo "  FAIL ($local_issues issue(s))"
    fi

    VIOLATIONS=$((VIOLATIONS + local_issues))
  done <<< "$CHANGED"
fi

echo ""
echo "=== SKILL.md change check ==="
check_skill_changes || true

echo ""
echo "=== Contract v2 migration: $CONTRACT_OK migrated, $CONTRACT_MISSING pending (WARN only, non-blocking) ==="

echo ""
echo "=== Result: $VIOLATIONS violation(s) ==="

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "::error::Content validation failed with $VIOLATIONS violation(s). See log above."
  exit 1
fi

echo "::notice::Content validation passed."
