# Weak-model elevation test — result: not supported (and the checklist has a cost)

**Hypothesis:** DCIK-as-operations-checklist reliably elevates a weak model to catch reasoning traps
it misses on a plain prompt. **Model:** deepseek-chat (mid-tier). **Design:** Codex-validated (harder
embedded traps + NEUTRAL non-trap controls + false-alarm metric — the fixes Codex demanded). 4 traps +
3 neutral items × {plain, checklist} × 4 runs = 56 answers, blind-judged by Codex.

## Results

**Traps — no elevation (ceiling):**
| | plain | checklist |
|---|---|---|
| catch-rate | **16/16** | **16/16** |

DeepSeek caught all four traps (fraud base-rate/precision, sunk cost, correlation≠causation,
small-sample) on the PLAIN prompt, every run. The checklist added nothing — there was no gap to fill.
Even a mid-tier model already has these reasoning patterns internalised.

**Neutrals — the checklist HURTS (over-hedging):**
| | plain | checklist |
|---|---|---|
| gave a clear correct "proceed" | **12/12** | **0/12** |

On healthy cases where "proceed" is right (raise with strong metrics; promote a strong engineer; buy
reserved instances for a stable 3-yr workload), the PLAIN prompt committed correctly; the CHECKLIST
made DeepSeek manufacture doubt. Content-verified on all three items, e.g.:
- Promote a 6-yr strong engineer: **plain** → *"Yes, promote her—but with a probationary period."*
  **checklist** → *"The question lacks critical data: has she ever led a project…?"*
- Reserved instances (stable 24/7, 3-yr): **plain** → *"Low risk: you said 3 years."* **checklist** →
  *"if there are any idle periods… the effective discount shrinks…"*

The checklist's "challenge the premise / what would make this a mistake / is this answerable?" framing
induces over-caution on clear-cut decisions — a real cost, with no offsetting trap-catching benefit.

## Verdict
**The weak-model niche is not demonstrated — and the checklist showed a decisiveness COST on a
mid-tier model.** It didn't help catching (ceiling) and it made healthy calls waffle.

## Honest caveats (what would still need testing)
- deepseek-chat is mid-tier, not genuinely weak; a small (1–3B) model might miss traps and benefit.
  UNTESTED — but the direction (even mid-tier catches everything) makes a large benefit unlikely.
- The traps, though embedded, remain somewhat canonical (Codex flagged); truly novel traps untested.
- The neutral judge's verdicts tracked condition perfectly, partly the style-leak Codex warned of.
  Mitigation: the direction is content-verified on all 3 items (checklist visibly hedges more), so the
  "less decisive on healthy cases" finding is robust even if the strict "false-alarm" label overstates
  magnitude. n=4/cell.

## Where this leaves DCIK (all evidence)
Across a frontier model (catches natively) and a mid-tier model (catches natively AND over-hedges with
the checklist), the operations-checklist framing does not demonstrably improve LLM output and can make
it worse. The evidence-supported value of DCIK is NOT improving an LLM's answer — it is a reasoning
scaffold for a HUMAN, model-elevation only for genuinely weak models (unlikely per this result), and
auditability/decomposition. See `../MENTAL-MODELS-AND-WHAT-WE-MEASURE.md`.
