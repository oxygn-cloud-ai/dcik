---
name: decide
version: 1.2.0
description: Katabasis Decision Interview — a structured human+LLM decision process whose engine is cross-model adversarial dissent aimed at YOUR reasoning. For high-stakes, hard-to-reverse decisions. Interactive: it interviews you, then a different model attacks your reasoning and a third adjudicates.
user-invocable: true
disable-model-invocation: false
allowed-tools: Agent, AskUserQuestion, Read, Write, Bash(date:*), Bash(mkdir:*), WebSearch
argument-hint: "[the decision you're facing]"
---

# Katabasis Decision Interview (`/decide`)

**What this is — and is NOT.** This does NOT write you an assessment. It interviews *you*, then turns
a genuinely different model loose on your reasoning, and a third model adjudicates whether your
answers held. The value is not a better memo (a frontier model already writes those); it is
**overriding your own bias and the model's default agreeableness** on a decision that matters.

> Evidence basis: 7 prior evals showed a single LLM does not out-reason itself with more perspectives —
> it already has them. The one mechanism a single model cannot provide is *genuine dissent from a
> different mind*. That is this tool's entire engine. See `../../eval/MENTAL-MODELS-AND-WHAT-WE-MEASURE.md`.

**Use it only for** consequential, hard-to-reverse decisions where being wrong is expensive. It costs
you 30–60 minutes of real engagement. It is the wrong tool for quick or low-stakes calls.

## Roles (must be THREE different models — this is non-negotiable)
- **Interviewer/Synthesizer** = the model running this skill (you, the assistant).
- **Challenger** = a DIFFERENT model (`Agent(subagent_type: "codex:codex-rescue")`, or another via API).
  Its only job is to attack the human's reasoning. It never resolves or softens.
- **Adjudicator** = a THIRD model/agent that marks each Challenger objection *addressed* or *unaddressed*
  against an explicit evidentiary standard. The Synthesizer may NEVER grade its own challenges.
If a second/third model is unavailable, STOP and tell the user the core mechanism cannot run — do not
silently degrade to single-model self-dissent (that is the failure mode this tool exists to avoid).

## Anti-coercion safeguards (enforced throughout)
1. Unresolved objections **cap** the final confidence (process length can never inflate it).
2. A concession is only counted as a genuine update if the human states *why* (evidence). Bare
   capitulation is recorded as "conceded without reason" and does NOT resolve the objection.
3. Any reframe the Challenger introduces is itself evidence-backed and adjudicated — you are not
   allowed to talk the human into a slick-but-unsupported new framing.
4. The output states plainly: **process completeness is not truth.** It shows what was NOT resolved.
5. Withhold-endorsement is a valid, expected outcome. If objections stand, you do NOT recommend.

## The interview

### Phase 0 — Frame & surface the lean
Ask the human (AskUserQuestion or direct): What exactly are you deciding? Stakes? How reversible?
Deadline? **What's your current lean, and what is it resting on?** Do not proceed without an explicit
lean — it is the thing to be attacked. Create `decide_<slug>/` and record Phase 0.

### Phase 1 — Attack the premise (Synthesizer)
Invert their framing. "You're deciding X — what if the real question is Y? Whose interest does your
framing serve? What are you assuming that, if false, flips this?" Require the human to answer.

### Phase 2 — Run the operations ON the human (each gated by a required artifact)
- **Outside view:** establish the reference class; state the base rate (WebSearch if needed). "Does
  your lean survive it?" Human must engage the number.
- **Premortem:** "It's a year on and this failed. *You* name the top cause." (Human generates.)
- **Circle of competence:** "Mark each key judgment: do you know this, or are you guessing?" Guesses
  become risks, not facts.
- **Bias interrupt:** reflect their own emphasis back ("upside 3×, downside 1×") — anchor or real?

### Phase 3 — Extract the private context the models cannot have
Systematically pull the load-bearing facts only the human knows (the room, the terms, the people) and
write them down. This is where human+model beats model-alone.

### Phase 4 — Cross-model dissent + adjudication (the engine)
1. Assemble the **case file**: the decision, the human's lean + reasoning, the Phase-2 artifacts, the
   Phase-3 private facts.
2. Spawn the **Challenger** (`challenger.md` as its brief) — a DIFFERENT model — to produce the
   strongest disconfirming case: the specific objections, each with the evidence/test that would
   settle it.
3. Present each objection to the human. Require a specific rebuttal (not a hand-wave).
4. Spawn the **Adjudicator** (`adjudicator.md`) — a THIRD model — with each objection + the human's
   rebuttal. It returns ADDRESSED / UNADDRESSED / CONCEDED-WITHOUT-REASON per the rubric. The
   Synthesizer does not overrule it.
5. Loop any UNADDRESSED objection back to the human once more, then freeze the ledger.

### Phase 5 — Decide (with the safeguards)
- The human states the decision **in their own words**, plus a confidence — but the confidence is
  **capped** by the number/severity of unresolved objections (safeguard 1).
- Write `decide_<slug>/RECORD.md` per `record-template.md`: the decision, tested premises, base rates,
  premortem, the full objection ledger (addressed/unaddressed), residual uncertainty, what would change
  the answer, and the explicit "process completeness ≠ truth" note.
- If material objections remain UNADDRESSED, the recommendation is **withheld**: report "not resolved —
  here is what you still need," not a decision.

## Honest limits (state these to the user at the end)
- This is validated in mechanism only; whether it beats a strong adversarial chat *for real humans* is
  an open human-subjects question (`../../eval/flavor1/HUMAN-STUDY.md`).
- Its value is largest for the decision-maker who would otherwise get agreement from a plain chat; a
  disciplined adversarial self-prompter gets less from it.
