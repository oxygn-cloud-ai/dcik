#!/usr/bin/env bash
# audit-run.sh -- offline auditor for a DCIK RUN_MANIFEST.json (Keystone 3).
#
# Verifies enactment, not just paperwork. Two layers:
#   1. STRUCTURAL (always, offline): search/source minimums met; every CRITICAL/HIGH finding
#      is incorporated into a real assessment version or explicitly REJECTED; every
#      contradicting source carries a URL + a quoted passage + a why.
#   2. ENTAILMENT SAMPLING (needs network): fetch a sample of cited contradicting sources and
#      check the QUOTED PASSAGE actually appears on the page. Whether it truly *contradicts*
#      is flagged for human/second-model judgement -- automatable passage-presence is the
#      mechanical half; entailment is the judgement half.
#
# Honest scope: this makes fabrication EXPENSIVE and DETECTABLE ON AUDIT. It does not make
# fabrication impossible -- a determined faker can quote real passages out of context. The
# quoted-passage requirement plus sampling raises the cost and enables spot-checks.
#
# Usage:
#   bash eval/audit-run.sh RUN_MANIFEST.json [--sample N] [--no-fetch]
# Exit 0 = clean; 1 = structural violations; 2 = usage/error.

set -uo pipefail

MANIFEST="${1:-}"
SAMPLE=2
FETCH=1
shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --sample) SAMPLE="${2:-2}"; shift 2;;
    --no-fetch) FETCH=0; shift;;
    *) echo "unknown arg: $1"; exit 2;;
  esac
done

[ -z "$MANIFEST" ] && { echo "Usage: bash eval/audit-run.sh RUN_MANIFEST.json [--sample N] [--no-fetch]"; exit 2; }
[ ! -f "$MANIFEST" ] && { echo "ERROR: $MANIFEST not found"; exit 2; }
command -v jq >/dev/null || { echo "ERROR: jq required"; exit 2; }
jq empty "$MANIFEST" 2>/dev/null || { echo "ERROR: $MANIFEST is not valid JSON"; exit 2; }

VIOL=0
MIN_SEARCH=$(jq -r '.min_searches_per_cycle // 5' "$MANIFEST")
MIN_SRC=$(jq -r '.min_contradicting_sources_per_cycle // 3' "$MANIFEST")
echo "=== DCIK Run Audit: $MANIFEST ==="
echo "min searches/cycle: $MIN_SEARCH   min contradicting sources/cycle: $MIN_SRC"
echo ""

# ── Layer 1: structural ────────────────────────────────────────────
NCYCLES=$(jq '.cycles | length' "$MANIFEST")
VERSIONS=$(jq -c '.assessment_versions // []' "$MANIFEST")

for i in $(seq 0 $((NCYCLES - 1))); do
  N=$(jq -r ".cycles[$i].n" "$MANIFEST")
  NS=$(jq -r ".cycles[$i].searches | length" "$MANIFEST")
  NSRC=$(jq -r ".cycles[$i].contradicting_sources | length" "$MANIFEST")
  echo "--- cycle $N: $NS searches, $NSRC contradicting sources ---"

  if [ "$NS" -lt "$MIN_SEARCH" ]; then
    echo "  VIOLATION: only $NS searches (min $MIN_SEARCH)"; VIOL=$((VIOL + 1))
  fi
  if [ "$NSRC" -lt "$MIN_SRC" ]; then
    echo "  VIOLATION: only $NSRC contradicting sources (min $MIN_SRC)"; VIOL=$((VIOL + 1))
  fi

  # every contradicting source needs url + quoted_passage + why
  BADSRC=$(jq -r "[.cycles[$i].contradicting_sources[] | select((.url//\"\")==\"\" or (.quoted_passage//\"\")==\"\" or (.why_it_contradicts//\"\")==\"\")] | length" "$MANIFEST")
  if [ "$BADSRC" -gt 0 ]; then
    echo "  VIOLATION: $BADSRC contradicting source(s) missing url/quoted_passage/why"; VIOL=$((VIOL + 1))
  fi

  # every CRITICAL/HIGH finding must be incorporated into a real version OR explicitly REJECTED
  while IFS= read -r finding; do
    [ -z "$finding" ] && continue
    FID=$(jq -r '.id' <<<"$finding")
    SEV=$(jq -r '.severity' <<<"$finding")
    RES=$(jq -r '.resolution // ""' <<<"$finding")
    VER=$(jq -r '.incorporated_in_version // ""' <<<"$finding")
    if [ "$SEV" = "CRITICAL" ] || [ "$SEV" = "HIGH" ]; then
      if [[ "$RES" == REJECTED* ]]; then
        : # explicitly rejected with reason -- acceptable
      elif [ -z "$VER" ]; then
        echo "  VIOLATION: $SEV finding $FID has no incorporated_in_version and is not REJECTED"; VIOL=$((VIOL + 1))
      elif ! jq -e --arg v "$VER" '.assessment_versions | index($v)' "$MANIFEST" >/dev/null; then
        echo "  VIOLATION: $SEV finding $FID claims version '$VER' not in assessment_versions $VERSIONS"; VIOL=$((VIOL + 1))
      fi
    fi
  done < <(jq -c ".cycles[$i].findings[]?" "$MANIFEST")
done

# ── Layer 2: entailment sampling ───────────────────────────────────
echo ""
echo "=== Entailment sampling (quoted-passage presence) ==="
ALLSRC=$(jq -c '[.cycles[].contradicting_sources[]]' "$MANIFEST")
TOTAL=$(jq 'length' <<<"$ALLSRC")
if [ "$TOTAL" -eq 0 ]; then
  echo "  no contradicting sources to sample"
else
  K=$SAMPLE; [ "$K" -gt "$TOTAL" ] && K=$TOTAL
  # deterministic-ish sample: first K (override by pre-shuffling if desired)
  for j in $(seq 0 $((K - 1))); do
    URL=$(jq -r ".[$j].url" <<<"$ALLSRC")
    PASSAGE=$(jq -r ".[$j].quoted_passage" <<<"$ALLSRC")
    SNIPPET=$(printf '%s' "$PASSAGE" | cut -c1-60)
    if [ "$FETCH" -eq 1 ] && command -v curl >/dev/null; then
      BODY=$(curl -s -L --max-time 20 "$URL" 2>/dev/null | tr -d '\0')
      if [ -z "$BODY" ]; then
        echo "  [$j] FETCH-FAIL $URL — could not retrieve (manual check needed)"
      elif printf '%s' "$BODY" | grep -qiF -- "$(printf '%s' "$PASSAGE" | cut -c1-40)"; then
        echo "  [$j] PASSAGE-FOUND $URL"
        echo "        -> MANUAL: confirm this passage actually CONTRADICTS the assessment (\"${SNIPPET}...\")"
      else
        echo "  [$j] PASSAGE-ABSENT $URL — quoted passage not found on page (possible fabrication)"
        echo "        quoted: \"${SNIPPET}...\""
      fi
    else
      echo "  [$j] MANUAL $URL — fetch disabled; verify passage presence + entailment by hand"
      echo "        quoted: \"${SNIPPET}...\""
    fi
  done
fi

echo ""
echo "=== Structural result: $VIOL violation(s) ==="
[ "$VIOL" -gt 0 ] && exit 1
exit 0
