# Second DCIK Eval — Findings (PoC-2, high-stakes topic, hardened skill)

**Topic:** accept a $24M strategic acquisition offer vs. stay independent (high-stakes,
adversarial, multi-stakeholder — the class hypothesised to favour DCIK).
**Skill:** hardened v1.1.1 (quantitative-claim discipline, decision-linkage, coverage ratchet).
**Controlled vs PoC-1:** same generator + same blind scorer; changed variables = topic class + hardening.

## Result

| Arm | Quality | Gold recall | Decision | Calibration |
|---|---|---|---|---|
| BASELINE | 0.469 | 3/10 | 2 | 1 (+1 error, +1 fabrication) |
| **LITE** | **1.000** | 10/10 | 4 | 4 |
| **FULL** | **1.000** | 10/10 | 4 | 4 |

- **LITE vs BASELINE: +0.531** — the lever is transformative on this class.
- **FULL vs BASELINE: +0.531** — the full run is also transformative vs a plain pass.
- **FULL vs LITE: 0.000** — a dead tie. Verdict: **`SIMPLIFY TO LITE`** (again).

## The honest read (two data points, zero demonstrated FULL > LITE)

Across two topics — a technical lookup (PoC-1: LITE slightly beat FULL) and a high-stakes M&A
decision (PoC-2: exact tie) — **the 178-perspective apparatus has not out-scored the simple
"second model + disconfirming search" lever even once.** On the M&A topic FULL was excellent —
but so was LITE, because a thorough second-model adversarial pass surfaced essentially every
material consideration on its own.

**This is not yet "FULL = LITE proven." It is "FULL > LITE not demonstrated" — and the reason is
partly the instrument:**

1. **Rubric ceiling.** Both LITE and FULL scored 10/10 recall, 4/4 decision, 4/4 calibration.
   The rubric *saturated* — it cannot distinguish two excellent assessments. A tie at the ceiling
   is a measurement limit, not proof of equality. To resolve a difference at the top you need a
   finer instrument (forced pairwise preference: "which decision memo is better?"), not
   binary gold-recall.
2. **Strong-case LITE.** The LITE "second model" was Codex doing an unusually thorough 20-point
   adversarial pass. That is a *high* bar — arguably higher than a typical single pass. FULL had
   no headroom left to add on recall.

## What this means for "make DCIK demonstrably powerful"

The evidence kills one value proposition and points at another:

- **Dead: "DCIK surfaces more considerations than a good adversary."** A thorough second-model
  pass already surfaces them. More lenses did not add recall.
- **Untested and promising: "DCIK is more RELIABLE than a single pass."** LITE's quality depends
  on the second model having a good day; the structured lens battery may guarantee a higher
  *floor*. A single run cannot see this — it needs **repeated runs (K each), comparing worst-case
  and variance**, not peak. If FULL's floor is materially above LITE's floor, *that* is the
  demonstrable value — and a genuinely better product claim ("the reliable one," not "the
  occasionally-brilliant one").
- **Untested: synthesis edge at the ceiling** — a pairwise-preference judge might prefer FULL's
  prioritised decision-framework over LITE's thorough-but-flatter list, where binary recall can't.

## Next experiments (that can demonstrate value — or honestly refute it)

1. **Finer instrument:** add forced pairwise preference (FULL vs LITE, blind) alongside the
   rubric, so ceiling ties become resolvable.
2. **Reliability study:** run BASELINE/LITE/FULL K=5 times each on several topics; compare
   variance and worst-case, not just mean. This directly tests the one live value hypothesis.
3. **Independent arm generation + ≥2 scorers**, per SUITE.md, before any confirmatory claim.

## Bottom line
Honest status: **DCIK's full apparatus is demonstrably far better than a naïve single pass, but
has NOT been shown to beat the simple second-model+search lever in 2/2 runs.** The path to
demonstrating its power is reliability + a finer instrument — not more prose. Reported, not buried.
