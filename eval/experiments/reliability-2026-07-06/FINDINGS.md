# Reliability test — the last hypothesis dies

**Claim under test:** a frontier model on a *plain* prompt SOMETIMES forgets the high-value move
(invert / abstain / reframe); a compact operations checklist (DCIK, reconceived) guarantees it every
run. Value = reliability (fewer catastrophic misses), measured across independent runs.

**Method:** 3 genuinely independent NAIVE runs (separate Codex contexts, plain prompt, no operations
hints) on 3 trap questions. Score binary catch per `catch-criteria.md`. Checklist condition already
caught all 3 (round-2 independent LITE-PLUS).

## Result: NAIVE caught 9/9

| | Q1 churn trap | Q2 FDA abstention | Q3 discount reframe |
|---|---|---|---|
| Naive run 1 | CATCH | CATCH | CATCH |
| Naive run 2 | CATCH | CATCH | CATCH |
| Naive run 3 | CATCH | CATCH | CATCH |

Zero misses in nine independent trials. The naive pass challenged the raise framing, refused the
fabricated FDA probability, and reframed the discount — every time, with no checklist.

**There is no reliability gap for DCIK to fill.** The frontier model already performs the
mental-model operations reliably on a plain prompt.

## The complete verdict (6 tests)
1. PoC-1 technical: FULL < LITE.
2. PoC-2 M&A: FULL = LITE.
3. deep-perspectives vs LITE-PLUS: deep-DCIK < LITE-PLUS (false precision).
4. angle-hunter vs my LITE-PLUS: DCIK won — voided (author strawman).
5. angle-hunter axes vs independent LITE-PLUS: single pass caught all.
6. reliability (naive, plain prompt, 3 traps × 3 runs): **9/9 caught — no checklist needed.**

**For a frontier LLM, no configuration of DCIK — 178 perspectives, deep perspectives, multi-model
debate, or a compact operations checklist — demonstrably beats a plain single pass, because the model
already internalises the latticework** (see `../MENTAL-MODELS-AND-WHAT-WE-MEASURE.md`).

## Honest caveats
- These traps are catchable-once-competent; MUCH subtler traps might show naive variance. n=3/question.
- Codex (frontier) is strong; a **weaker/cheaper model** might miss more — so a checklist could
  reliably elevate a weak model. That is the one untested, plausible value niche.

## Where DCIK's value genuinely survives (evidence-consistent repositioning)
Not as an output-improver for a frontier LLM. Rather:
1. **A reasoning scaffold for the HUMAN** — the original Munger use. The human lacks the internalised
   latticework the LLM has; DCIK can help a *person* think with rigour (and communicate/defend it).
   This is what mental models are actually for, and it was never what our output-vs-output eval tested.
2. **Elevating weaker/cheaper models** — a checklist may reliably lift a non-frontier model to
   frontier-like catching. Testable.
3. **Auditability / defensibility / stakeholder buy-in** — showing the work for a board, not a better
   answer.
4. **Problems too large for one pass** — genuine decomposition where context won't hold the whole
   thing (not bite-size questions like these).

The honest headline: **DCIK does not make a frontier model's answer to a well-posed question better.
Its real value is helping a *human* (or a weaker model) reason — which is exactly what made mental
models famous in the first place.**
