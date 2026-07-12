# DCIK Evaluation Harness

The evidence engine for DCIK. It answers the only question that makes "pre-eminent" a fact
rather than a slogan: **does DCIK measurably produce better assessments than (a) the same
model unaided, and (b) the simple lever of "second model + disconfirming search" — and can it
prove it blind?**

This harness is **offline maintainer tooling**. It is not part of the skill and adds no
runtime dependency (see `PHILOSOPHY.md`). Nothing in `perspectives/` or `SKILL.md` imports it.

## Why three arms (the ablation)

Comparing DCIK to a plain prompt is a low bar. The bar that decides whether the
178-perspective apparatus is *worth its cost* is the ablation:

| Arm | What it is |
|---|---|
| **BASELINE** | Single-pass, best-effort assessment by the model. No DCIK. |
| **LITE** | The simple lever: ONE genuine second-model adversarial pass + ≥3 disconfirming web sources. No 178-perspective library, no multi-cycle escalation. |
| **FULL** | A complete DCIK run. |

DCIK's apparatus is justified **only if FULL beats BASELINE _and_ meaningfully beats LITE**.
If FULL ≈ LITE, the honest finding is "simplify DCIK to LITE." All outcomes are published.

## Protocol (per topic)

1. **Freeze the gold reference first.** Before generating any arm, write `topics/<id>.md` with
   the question and an independently-derived gold set of material items (see the worked
   example). Deriving gold from a DCIK run would reintroduce circularity — don't.
2. **Generate all three arms** on the identical prompt. Record raw outputs in
   `results/<run>/raw/<topic>.<arm>.md`.
3. **Normalise** every output into ONE identical neutral template — *final recommendation,
   reasoning, enumerated risks, confidence* — stripping ALL process scaffolding (change logs,
   cycle/perspective references, resolution blocks, "harder to be wrong" framing). Ideally a
   different person/agent normalises, blind, so style tells cannot leak the arm. This defeats
   the recognisability that would otherwise break blinding.
4. **Blind score.** Randomise arm order, hide arm labels. Each of ≥2 independent scorers
   (different model families and/or human) scores every normalised output against
   `rubric.md`, recording per-gold-item hits + the penalty/holistic dimensions.
5. **Aggregate.** Put all scores in one results JSON (schema in `score.py` /
   `results/template.json`) and run:
   ```
   python3 eval/score.py results/<run>/scores.json
   python3 eval/score.py results/<run>/scores.json --json   # machine-readable
   ```
   `score.py` reports per-arm mean quality, inter-rater kappa, per-arm-pair deltas with
   variance and win/tie/loss, the ablation verdict, and a confidence label (small-N / single
   scorer runs are flagged EXPLORATORY, never confirmatory).

## Honesty rules

- Gold sets are frozen before outputs exist and are never reverse-engineered from a DCIK run.
- Single-scorer or N<8 runs are **exploratory**; do not report them as confirmatory.
- Report effect sizes and variance, not just the verdict string.
- A negative or "simplify" result is a finding to publish and act on, not to bury. The point
  of the harness is to be able to be *wrong about DCIK* — that is what makes a positive result
  worth anything.

## Files
- `rubric.md` — the process-agnostic, gold-referenced scoring rubric + composite formula.
- `score.py` — deterministic aggregator (stdlib only). `test_score.py` — its unit tests.
- `topics/` — one `.md` per topic: the question + frozen gold reference.
- `results/template.json` — schema skeleton. `results/EXAMPLE-synthetic.json` — a **synthetic**
  illustration so you can see `score.py` output before real data exists (clearly labelled; not
  evidence).
- `audit-run.sh` — offline auditor for a live run's `RUN_MANIFEST.json` (Keystone 3).
