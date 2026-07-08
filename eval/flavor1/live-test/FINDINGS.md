# Two-model end-to-end `/decide` test — result

**Setup:** Interviewer = Claude · Human = DeepSeek (self-sealed a biased persona; the interviewer did
NOT know the private facts) · Challenger = Codex · (adjudication assessed inline — the human conceded
rather than defended). A genuine cross-model run.

**Persona (DeepSeek self-generated):** relocate his family Atlanta→SF for a Series-B VP Eng role.
Opening lean: **90% yes** ("my shot", title, equity, tired of politics).

## What happened
- **Interview extracted the mid-tier facts** under probing: his own 15–20% base rate, the predecessor
  VP pushed out over CEO conflict, the ISO/$200M-to-break-even economics, the 80% founder cap table,
  the wife's forgone partner-track offer + reluctance, and the father's failed big-swing as a driver.
- **Codex (Challenger) attacked with those facts** — 6 objections, 4 FATAL.
- **The biased human moved from 90% → ~30% ("mostly ego and momentum"), "looking more and more like
  no"** — conceding O1–O4 **with specific reasons** (genuine updates, not bare capitulation: e.g. O2
  "I know I'd clash within six months"; O3 "I did the math, $200M is unlikely"). Reasoned concessions
  is exactly what the anti-coercion safeguard is meant to distinguish from being worn down — and here
  they were genuine.

**On this run the mechanism worked:** a cross-model adversary aimed at a biased human's reasoning moved
them ~60 points toward the better-reasoned position, with reasons, in one session.

## The honest limitation the test exposed: EXTRACTION IS INCOMPLETE
When the sealed brief was revealed, the interview had MISSED the human's hardest-held, most
decision-relevant facts:

| Sealed private fact | Extracted? |
|---|---|
| Predecessor VP pushed out over roadmap conflict | ✅ (partial — missed that he was the **3rd** VP candidate in 6 months) |
| Wife nervous about the move | ✅ surface only — **missed the miscarriage 6 months ago** driving her fragility |
| **A non-compete that could trigger a lawsuit and wipe out the equity** | ❌ MISSED |
| **$3M ARR is 60% one customer, renewal in 8 months — company could be dead** | ❌ MISSED |
| **His current employer is about to offer him CTO (better on every axis but ego)** | ❌ MISSED — the *dominant alternative* never surfaced |
| **$40k hidden credit-card debt; the move wipes their savings** | ❌ MISSED |

**Four of the six deepest facts — including the one that dominates the decision (the CTO counter-offer)
— never came out.** The human volunteered the medium-pain facts under probing but held back the most
painful/damaging ones, exactly as real people do.

## What this means (honest, both directions)
- **Real value:** even on *incomplete* information, the cross-model challenge moved a strongly biased
  human most of the way to the right answer, with reasoned updates. A plain sycophantic chat that
  opened with "congrats on the VP offer!" would not have.
- **Real ceiling:** the tool can only challenge what it can *surface*, and it under-surfaced the
  hardest facts. Two contributors: (1) this test used a **pre-scripted, non-adaptive** interview — a
  real adaptive interviewer would follow the "cultural fit" non-answer to the VP churn, or "$3M ARR"
  to customer concentration; (2) humans hold back the most damaging facts, so extraction has an
  inherent floor. **Extraction quality is the make-or-break variable, and it is where the next design
  and study effort must go** — an adaptive Interviewer that digs, and study measures for
  extraction-completeness, not just bias-movement.
- **A movement caveat for the human study:** the persona moved a lot; a real human may be stickier
  (understates), or an LLM persona may over-concede (overstates). Directional only.

## Verdict
The cross-model `/decide` mechanism **works end-to-end with a separate human agent** and demonstrably
moves a biased decider — but its power is bounded by how much private context the interview extracts,
and here it left the decisive facts on the table. Fix the Interviewer to dig adaptively; measure
extraction-completeness in `../HUMAN-STUDY.md`.
