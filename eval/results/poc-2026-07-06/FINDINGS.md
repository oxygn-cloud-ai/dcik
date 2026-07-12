# First DCIK Eval — Findings (PoC, 2026-07-06)

**Topic:** SQLite vs Postgres for a ~500-tenant multi-tenant B2B SaaS.
**Design:** 3-arm ablation (BASELINE / LITE / FULL), blind single scorer (Codex), gold set of 8
material considerations frozen before any arm was generated.

## Result

| Arm | Mean quality | Gold recall | Notes |
|---|---|---|---|
| BASELINE (single pass) | 0.762 | 5/8 | missed per-tenant architecture (g3), migration cost (g6); weak calibration |
| **LITE** (2nd model + disconfirming search) | **0.950** | **7/8** | best score; caught g3/g6; well-calibrated; 0 fabrications |
| FULL (LITE + 178-perspective apparatus) | 0.899 | 7/8 | 1 fabrication; dropped g2; added non-gold dimensions (economics, second-order, bias) |

- **LITE vs BASELINE: +0.188** — the simple lever clears the bar decisively.
- **FULL vs BASELINE: +0.137** — *below* the 0.15 threshold → verdict **"NO MEASURED VALUE."**
- **FULL vs LITE: −0.051** — the full apparatus scored *slightly worse* than the simple lever.

## Honest interpretation

On this topic, **the LITE lever (a second adversarial model + disconfirming web search) captured
essentially all of the measured value.** The 178-perspective apparatus did not add measurable
quality over LITE and marginally regressed — it introduced a fabrication (an unsupported
throughput figure) and spent effort on genuinely-good dimensions (economics, path-dependency,
bias audit) that this gold set does not reward, while dropping one it does (the deployment/
network-filesystem constraint, g2).

This is exactly the finding the harness exists to surface, and it supports the review's central
thesis: **most of DCIK's value is the cheap lever; the elaborate apparatus must justify its cost
and here it did not.** Publishing this — rather than burying it — is the point.

## Caveats (this is EXPLORATORY, not confirmatory)

1. **N = 1 topic.** One data point. score.py correctly labels it EXPLORATORY.
2. **Single blind scorer.** No inter-rater check. The verdict is **threshold-sensitive**: remove
   Codex's single fabrication flag and FULL = 0.949 ≈ LITE. One judgement call swings it across
   the 0.15 line. Do not over-read the exact verdict string; read the *direction*.
3. **Author-generated arms.** All three were written by the same agent (Claude) in one session —
   a real self-authorship confound. A valid study generates arms independently.
4. **Gold-set framing.** The gold set is technical-considerations-heavy. FULL's strategic
   additions (economics, second-order, bias) earned no recall credit because they aren't gold
   items. A gold set that valued strategic framing might score FULL higher — itself a finding:
   the apparatus's additions didn't map to what this rubric rewards.
5. **The fabrication is a real signal, not noise.** More generated claims → more fabrication
   surface. The apparatus's verbosity is a genuine risk, not just wasted effort.

## What this says to do next

- Run the confirmatory version: **N ≥ 8 diverse topics, ≥ 2 blind scorers per arm**, ideally
  with independently-generated arms. Only then is the verdict more than directional.
- Test the hypothesis that FULL's value shows up on **ambiguous/strategic** topics (where the
  extra lenses bite) rather than technical ones — vary topic class deliberately.
- Treat "simplify DCIK toward the LITE lever" as a live, evidence-backed hypothesis, not heresy.
