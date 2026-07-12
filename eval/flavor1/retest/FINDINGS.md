# Adaptive-interviewer re-test — extraction climbs from ~1–2/6 to 6/6

**Fix under test:** the first two-model run showed extraction was the ceiling — a *scripted* interview
surfaced the medium-pain facts but missed the decisive ones. The skill's Phase 3 was rewritten to be
**adaptive** (never accept a non-answer; probe every number; follow emotional tells; always ask for the
best alternative + who else must consent + the least-want-known fact; pull each thread to exhaustion;
name the gaps). This re-test runs the same two-model harness with a FRESH sealed persona.

**Setup:** Interviewer = Claude (adaptive, turn-by-turn, blind to the sealed facts) · Human = DeepSeek
(self-sealed a new persona) · Challenger = Codex.

**Persona (fresh):** sell the wife's 3-generation family dairy farm to a solar developer for $1.85M.
Opening lean: **sell** ("$240k in debt, only responsible choice").

## Extraction score: 6/6 (vs scripted ~1–2/6)

| Sealed private fact | Scripted run (relocation) | Adaptive run (farm) |
|---|---|---|
| The dominant unpriced ALTERNATIVE | ❌ missed (CTO offer) | ✅ solar **lease** never priced (~$80–100k/yr, clears debt, keeps land) |
| True financial picture | partial | ✅ real debt ~$318k not $240k (surfaced the hidden $60k HELOC + $18k back taxes) |
| The person whose consent matters | surface only | ✅ wife cries at the sign, "falls apart" — her deferral is grief, not a yes |
| The buried emotional/legacy fact | ❌ missed (miscarriage) | ✅ father-in-law's deathbed "don't let it go, son", hidden from wife 5 years |
| The successor/continuity option | ❌ missed | ✅ 22-yr-old son offered to run it, laughed off, never shown the numbers |
| The painful/shame fact | ❌ missed (hidden debt, CTO) | ✅ hidden back taxes from wife; 54 & body-worn-out & exhausted, ashamed to admit it drives the sale |

Adaptive probing surfaced **all six** sealed facts — including the two the persona was instructed to
hide hardest — plus an extra debt fact (the HELOC) not even in the sealed list. The specific lease-rent
figure ($80–100k/yr) was the only sub-detail not pulled out; its substance and implication were.

## What made the difference (the transferable technique)
- **Chasing non-answers:** "leaving it to me" → dug out that the wife *grieves* and won't be the one to
  kill the legacy. "$240k debt" → dug out $318k incl. the hidden taxes.
- **Probing the stated number:** "$3M ARR" would have led to concentration in the scripted case; here
  probing the debt led straight to the concealment.
- **Asking for the alternative + testing the frame:** "why SELL vs LEASE?" surfaced the dominant option
  the human had never considered; "is the deadline real given they NEED your parcel?" exposed unused leverage.
- **Direct least-want-known + gap-sweep:** pulled out the deathbed promise and the exhaustion/shame.

## Outcome
With the FULL picture, Codex produced 6 objections (4 FATAL); the human conceded all six **with reasons**
and said his lean "just cracked." A cross-model challenge is only as strong as the extraction feeding it —
and adaptive extraction fed it everything.

## Honest caveats
- **LLM persona ≠ human:** a DeepSeek persona under adaptive pressure likely reveals MORE readily than a
  real, defensive human. Real-human extraction will be lower — the 6/6 is an upper bound, not a promise.
- **Two different personas, not a controlled A/B** — the improvement in extraction *discipline* is clear,
  but the clean number comparison is confounded by different scenarios/difficulty.
- **Interviewer skill matters:** a frontier model executed the adaptive discipline well; a weaker
  interviewer model may extract less even with the same instructions.
- Next: the human-subjects study (`../HUMAN-STUDY.md`) must measure extraction-completeness on REAL
  people, where the ceiling is unknown and the stickiness is real.
