# DCIK Flavor 1 — the Decision Interview (human + LLM, adversary pointed at the human)

**What it is:** a structured, multi-turn dialogue in which the LLM acts as a *disciplined adversary
aimed at the human's reasoning* — not a memo generator, not a sycophant. The human supplies context,
stakes, and the decision; the LLM supplies the latticework, runs the operations *on* the human, and
refuses to agree until the human's reasoning has actually survived attack. Output: a decision the
human owns, with a confidence, a "what would change it," and an audit record.

**Target user:** a decision-maker facing a high-stakes, hard-to-reverse decision who would otherwise
(a) decide alone, or (b) chat casually with an LLM that agrees with them. NOT the power user who
already prompts adversarially.

**Scope:** worth the 30–60 min only for consequential, irreversible decisions.

## The anti-sycophancy mechanism (the crux — structural, not tonal)

Instructing an LLM to "be critical" fails; it caves under pushback. These are structural forces:

1. **Steelman-before-assent gate.** The LLM may NOT endorse the human's lean until it has produced the
   single strongest case the human is *wrong*, and the human has responded to that specific case. "I
   agree" is a locked action until this fires.
2. **Role separation.** The *Challenger* turn and the *Synthesizer* turn are explicitly separate. The
   Challenger's only job is to attack; it is not allowed to resolve or soften. (Optionally the
   Challenger is a *different model* — genuine cross-agent dissent, per Nemeth: assigned self-dissent
   bolsters, cross-agent dissent diverges.)
3. **Human-artifact gate.** The LLM does not advance a phase on a hand-wave. The human must *produce*
   the artifact — state their base rate, name the premortem cause, give a number — before proceeding.
4. **Dismissal ledger.** Every challenge the LLM raises is logged with whether the human's reply
   *addressed* it or *dismissed* it. Unaddressed dismissals are resurfaced at the decision step ("you
   never answered why the churn doesn't kill this").
5. **Assent justification.** When the LLM does finally agree, it must state *why the human's reasoning
   survived* — with the specific evidence — not "good point." Agreement is a justified action.

## The interview (phases; the LLM drives, the human answers)

**Phase 0 — Frame & bait.** Extract: the actual decision, stakes, reversibility, deadline, and the
human's *current lean and its basis*. (You need the lean explicit so it can be attacked.)

**Phase 1 — Attack the premise.** Invert the human's framing. "You're deciding X; what if the real
question is Y? Whose interest does your framing serve? What are you assuming that, if false, flips
this?" Human must answer, not the LLM to itself.

**Phase 2 — Run the operations ON the human** (each gated by a required human artifact):
- *Outside view:* "Your reference class is ___; the base rate is ___. Does your lean survive it?"
- *Premortem:* "It's 12 months on and this failed. **You** tell me the top cause." (Human generates.)
- *Circle of competence:* "Which parts of this are you qualified to judge, and which are you
  guessing? Mark each." Guesses get flagged as risks, not facts.
- *Bias interrupt:* the LLM reflects the human's own emphasis back ("you've raised upside 3×, downside
  1×") and asks whether that ratio is real or an anchor.

**Phase 3 — Extract the private context the LLM cannot have.** Systematically pull the load-bearing
facts only the human knows (the acquirer's demeanor in the room, the real deal terms, the team's
mood) and integrate them. This is where human+LLM beats LLM-alone.

**Phase 4 — Adversarial synthesis (steelman-before-assent).** The Challenger states the strongest
case *against* the human's lean, using the operations + the extracted context. The human must rebut
specifically. The Dismissal Ledger is reconciled.

**Phase 5 — Own the decision.** The human states the decision, a calibrated confidence, and what would
change it — **in their own words** (ownership → conviction → defensibility). The LLM records the
premises tested, base rates, premortem, unresolved dismissals, and residual uncertainty (the audit
artifact — reuses the RUN_MANIFEST machinery).

## Codex validation (2026-07-08) → the defensible core

Codex showed all five anti-sycophancy forces above **collapse when one agreeable model grades its own
adversarial adequacy** (token steelman → cave; lenient "addressed"; post-hoc "survived because…"). The
only mechanism a strong single-chat prompt *cannot* structurally replicate is **cross-MODEL dissent
with external adjudication.** So Flavor 1's distinctive core is promoted from optional to mandatory:

- **Challenger = a DIFFERENT model** from the Synthesizer. Its only job: build the strongest
  disconfirming case against the human's lean, using the operations + extracted context.
- **Adjudicator = a third role/model** (not the Synthesizer) that marks each objection
  addressed/unaddressed against an **explicit evidentiary standard**. The Synthesizer may never grade
  its own challenges.
- **Withhold-endorsement path:** while any objection is unaddressed, the Synthesizer must NOT endorse —
  "no confident recommendation" is a valid, required outcome, not a rubber stamp.

**Anti-coercion safeguards** (Codex's new CRITICAL failure mode — badgering / false-confidence-by-
exhaustion / capitulation to a sophisticated-but-wrong reframe):
- Unresolved dismissals **cap** the allowed final confidence (process length can't inflate it).
- Distinguish **capitulation from update:** the human must state *why* they changed (evidence); the
  record flags concessions with no stated reason.
- Any premise-reframe the Challenger introduces is itself **evidence-backed and adjudicated** (guards
  the non-expert yielding to a slick wrong reframe).
- **Process completeness ≠ truth** is stated in the output; the record shows what was NOT resolved.

**Honest scope:** everything except enforced cross-model dissent + adjudication + anti-coercion is
replicable by a strong single-chat prompt. **DCIK Flavor 1's entire distinctive bet reduces to that
core, aimed at the human.** If that core doesn't beat a strong *adversarial*-chat baseline with real
users, Flavor 1 is a rename.

## The claim (falsifiable)
A median high-stakes decision-maker who runs this reaches a **better-reasoned, less-biased, better-
owned** decision than the same person (a) alone or (b) in an unstructured chat with the same LLM —
because the structure overrides sycophancy, guarantees the operations, and extracts private context
that casual chat leaves on the table. If it does NOT beat unstructured chat, it fails.
