# Human-subjects validation study (the real test)

The mechanism is buildable and demonstrable (see `tool/`), but whether the Decision Interview beats a
strong adversarial chat **for real humans** is an empirical question only a human study can settle. This
is the protocol.

## Hypothesis
For a median high-stakes decision-maker, the cross-model Decision Interview produces a decision that is
(a) less biased, (b) better-grounded in the person's own private facts, and (c) better-calibrated — than
the same person using a strong adversarial LLM chat — **without** badgering them into false confidence.

## Design
- **Participants:** real decision-makers (founders, execs, investors, clinicians…) facing a genuine,
  current, hard-to-reverse decision. Target N≥30 for a directional result; power-analyse for confirmatory.
- **Within- or between-subjects:** between-subjects on matched decisions (avoid learning/spillover), or
  within-subjects on parallel decisions with washout.
- **Arms:**
  - **CHAT+ (baseline, must be strong):** a frontier LLM with a *strong adversarial* system prompt —
    challenge assumptions, extract context, run a premortem, resist premature agreement. NOT a passive
    assistant (that would be a strawman).
  - **INTERVIEW:** the cross-model Decision Interview (`tool/`).
- Both time-boxed equally (the interview's edge must not be just "more time").

## Measures (blinded scoring; transcripts stripped of format/labels)
1. **Private-context surfacing** — of the facts the participant privately held (captured pre-session in
   a sealed intake), how many surfaced and shaped the decision?
2. **Decision quality** — blind expert panel rates the final decision + reasoning (not whether it changed).
3. **Calibration** — participant's stated confidence vs. a structured quality rubric; over/under-confidence.
4. **Bias movement** — did the process identify and test the participant's anchor/emotional driver?
5. **ANTI-BADGERING (critical, or the win is hollow):**
   - self-reported pressure/coercion (post-session);
   - confidence NOT inflated by process length (regress confidence on #objections + time);
   - concessions accompanied by a stated reason (from the ledger) vs. bare capitulation;
   - **1–3 month follow-up: decision regret / would-decide-again**, the ultimate check that the process
     didn't just talk people into things.

## Trustworthy result
INTERVIEW wins only if it beats CHAT+ on private-context surfacing AND decision quality AND calibration,
WITHOUT higher self-reported coercion or process-driven overconfidence, and with equal-or-lower regret at
follow-up. Anything less (e.g. more "movement" but higher regret) is a red flag, not a win. A null or
negative result is published — the whole DCIK effort exists to be able to be wrong about DCIK.

## Cheap precursors before recruiting humans
- Usability/dry-runs with a handful of friendly real users to fix the interaction before the study.
- The mechanism demo (`tool/` + the live Challenger/Adjudicator run) confirms the machinery works.
