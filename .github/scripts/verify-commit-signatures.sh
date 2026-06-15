#!/usr/bin/env bash
# verify-commit-signatures.sh — DCIK commit signature enforcement
# Verifies every commit in a PR is signed by an allowed GPG key.
# Exit 0 = all commits signed and trusted. Exit 1 = violations found.
#
# Usage:
#   bash .github/scripts/verify-commit-signatures.sh [--base <branch>]
#
# Environment:
#   ALLOWED_SIGNING_KEYS  — space-separated list of GPG key fingerprints that
#                           are authorised to sign DCIK commits.
#
# Default allowed keys (replace/add as needed):
#   Add the full 40-char SHA-1 fingerprint (without spaces) for each
#   authorised committer. Run `gpg --list-keys --keyid-format LONG` to
#   find a key's fingerprint.

set -uo pipefail

ALLOWED_KEYS="${ALLOWED_SIGNING_KEYS:-}"
BASE_BRANCH=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE_BRANCH="$2"; shift 2 ;;
    *) echo "ERROR: Unknown argument: $1"; exit 1 ;;
  esac
done

# Determine commit range
if [ -n "$BASE_BRANCH" ]; then
  COMMIT_RANGE="${BASE_BRANCH}..HEAD"
elif [ -n "${GITHUB_BASE_REF:-}" ]; then
  COMMIT_RANGE="origin/${GITHUB_BASE_REF}..HEAD"
else
  # Default: compare against main
  COMMIT_RANGE="origin/main..HEAD"
fi

echo "=== DCIK Commit Signature Verification ==="
echo "Commit range: ${COMMIT_RANGE}"
echo ""

# Get the list of commits in the PR
COMMITS=$(git log "${COMMIT_RANGE}" --format='%H' 2>/dev/null) || {
  echo "ERROR: Could not list commits in range '${COMMIT_RANGE}'."
  echo "       Are you in a git repository with sufficient fetch depth?"
  exit 1
}

if [ -z "$COMMITS" ]; then
  echo "No commits to verify (range may be empty)."
  exit 0
fi

echo "Found $(echo "$COMMITS" | wc -l | tr -d ' ') commit(s) to verify."
echo ""

VIOLATIONS=0
TOTAL=0

while IFS= read -r hash; do
  [ -z "$hash" ] && continue
  TOTAL=$((TOTAL + 1))
  echo "--- Commit ${hash} ---"

  # Get the commit subject for display
  SUBJECT=$(git log -1 --format='%s' "$hash" 2>/dev/null)
  echo "  Subject: ${SUBJECT}"

  # Verify the commit signature
  VERIFY_OUTPUT=$(git verify-commit "$hash" 2>&1) || {
    echo "  FAIL: Commit ${hash} is NOT SIGNED or has a BAD signature."
    echo "  Output from git verify-commit:"
    echo "${VERIFY_OUTPUT}" | sed 's/^/    /'
    VIOLATIONS=$((VIOLATIONS + 1))
    echo ""
    continue
  }

  echo "  Signature: VALID"

  # Extract the signing key fingerprint
  FINGERPRINT=""
  while IFS= read -r line; do
    # Match "Primary key fingerprint: XXXX XXXX ..." or "      Key fingerprint = XXXX XXXX ..."
    if echo "$line" | grep -qiE '(Primary key fingerprint|Key fingerprint)'; then
      FINGERPRINT=$(echo "$line" | grep -oE '[A-F0-9]{4}( [A-F0-9]{4}){9}' | tr -d ' ')
      break
    fi
  done <<< "$VERIFY_OUTPUT"

  if [ -z "$FINGERPRINT" ]; then
    # Try alternative: extract from gpg output format "using RSA key XXXXXXXX"
    FINGERPRINT=$(echo "$VERIFY_OUTPUT" | grep -oE '(using RSA key|using ECDSA key|using Ed25519 key) [A-F0-9]{16,40}' | head -1 | awk '{print $NF}')
  fi

  if [ -z "$FINGERPRINT" ]; then
    echo "  WARN: Could not extract signing key fingerprint from commit ${hash}."
    echo "  Full verify output:"
    echo "${VERIFY_OUTPUT}" | sed 's/^/    /'
    # Without an allowlist configured, signed commits pass
    if [ -z "$ALLOWED_KEYS" ]; then
      echo "  PASS: No ALLOWED_SIGNING_KEYS configured — signature trusted by default."
    else
      echo "  FAIL: Cannot verify key against allowlist."
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
    echo ""
    continue
  fi

  echo "  Signing key: ${FINGERPRINT}"

  # Check against allowed keys (if configured)
  if [ -n "$ALLOWED_KEYS" ]; then
    KEY_ALLOWED=0
    for allowed in $ALLOWED_KEYS; do
      # Normalise: remove spaces for comparison
      normalised_fp=$(echo "$FINGERPRINT" | tr -d ' ')
      normalised_allowed=$(echo "$allowed" | tr -d ' ')
      if [ "${normalised_fp}" = "${normalised_allowed}" ]; then
        KEY_ALLOWED=1
        break
      fi
    done

    if [ "$KEY_ALLOWED" -eq 0 ]; then
      echo "  FAIL: Signing key ${FINGERPRINT} is NOT in the allowed keys list."
      VIOLATIONS=$((VIOLATIONS + 1))
    else
      echo "  PASS: Signing key is authorised."
    fi
  else
    echo "  PASS: No ALLOWED_SIGNING_KEYS configured — all valid signatures accepted."
  fi

  echo ""
done <<< "$COMMITS"

echo "=== Result: ${TOTAL} commit(s) checked, ${VIOLATIONS} violation(s) ==="
echo ""

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "::error::Commit signature verification failed: ${VIOLATIONS} commit(s) are unsigned or signed by an untrusted key."
  exit 1
fi

echo "::notice::All ${TOTAL} commit(s) have valid signatures."
exit 0
