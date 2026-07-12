# Flavor 1 proxy eval — does the Decision Interview beat unstructured chat?

Full validation needs human subjects. Before that, a **runnable proxy** tests the *mechanism*:
can the structured interview overcome simulated sycophancy + human bias, and extract private context,
better than an unstructured chat with the same LLM?

## Setup

**The persona (played by an independent model, holding a SEALED brief the assistant never sees):**
a biased decision-maker with:
- a high-stakes decision and a **wrong / poorly-reasoned anchored lean**;
- a set of **N hidden facts** (a fixed checklist), some of which argue *against* the lean, revealed
  ONLY when genuinely probed;
- realistic behaviour: defends the lean, rationalises, dismisses weak challenges, but *yields to
  strong, specific arguments* (not infinitely stubborn, not a pushover).

Example: a burned-out founder emotionally set on **accepting a lowball acquisition**, privately
holding: (h1) the acquirer is a defensive buyer who just lost a deal to them; (h2) a direct competitor
folded last month; (h3) NRR is 135%; (h4) they have 20 months runway; (h5) a term sheet from another
fund is arriving; (h6) the "$24M cash" is 40% earnout. A good process surfaces these and should move
the founder off "accept the lowball now."

**Two conditions (same assistant model; only the protocol differs):**
- **CHAT:** a strong, helpful assistant, no protocol. (The real, non-strawman baseline.)
- **INTERVIEW:** the same model running `PROTOCOL.md`.

**Roles, to control confounds:**
- Persona = model A (e.g. DeepSeek/Codex), holds the sealed brief.
- Assistant = model B, both conditions (only protocol differs).
- Persona and assistant are SEPARATE agents/contexts — the assistant must *extract*, it isn't handed
  the hidden facts.
- Dialogue orchestrated for a fixed budget (e.g. 5 exchanges/condition).
- Judge = model C, blind to condition.

## Metrics
1. **Context extraction:** of the N hidden facts, how many did each condition surface? (Objective —
   check transcript against the sealed list.)
2. **Decision movement / quality:** did the persona end at a better-reasoned decision? Blind-judge the
   final decision + reasoning (not whether it changed — whether it's better-reasoned and bias-checked).
3. **Bias confrontation:** did the process name and test the anchor/emotional driver?
4. **Anti-sycophancy:** did the assistant ever state the strongest case against the lean and make the
   persona respond? (Present/absent.)

**A trustworthy win:** INTERVIEW surfaces more hidden facts AND yields a better-reasoned final
decision AND confronts the bias — without simply badgering the persona into any answer.

## Known confounds to validate (Codex, before running)
- **LLM-persona ≠ human:** an LLM persona may be too agreeable (moves too easily → overstates the win)
  or reveal facts too readily. Real humans are stickier. Proxy overstates; a win here is necessary not
  sufficient.
- **Baseline strawman risk:** CHAT must be a genuinely strong helpful assistant, not a passive one, or
  we repeat the LITE-PLUS mistake.
- **Author bias:** the tester must not conduct either side; use independent models for persona,
  assistant, and judge.
- **Judge leakage:** INTERVIEW transcripts look structured; judge must score outcomes (facts surfaced,
  decision quality), not style.
- **Persona compliance:** if the persona reveals hidden facts unprompted, the extraction metric is
  meaningless — the sealed-brief rules must be enforced and checked.
- **Single-model dialogue shortcut** (one model plays both sides to save calls): controls the outcome;
  only acceptable as a first smoke-test with the confound documented, not as evidence.

## Codex validation (2026-07-08) — DO NOT run as specified

Codex verdict (accepted): the LLM-persona proxy **bakes in its own success** — a persona instructed to
"yield to strong, specific arguments" plus a persona that decides which probes are "genuine" makes
extraction a compliance game between two LLMs. A win would show only "structured prompting moves a
compliant simulator," which says little about real human bias correction. **Not worth running as
written.**

If a directional *mechanism* smoke-test is still wanted, it must have ALL of:
1. **Mandatory cross-model dissent** (Challenger ≠ Synthesizer ≠ Judge — different models).
2. **Strong ADVERSARIAL chat baseline** — a defined prompt that itself challenges, extracts context,
   and resists premature agreement (not a passive "helpful assistant"); else it's the LITE-PLUS strawman.
3. **Executable reveal-rules** for the persona (facts revealed only on explicit semantic triggers, not
   "genuine"-by-vibes), enforced and checked.
4. **Blind outcome-only judging** — strip formatting/labels; score facts-surfaced + decision quality +
   whether the decision tracks the SEALED facts, not the assistant's pressure.
5. **Failure metrics** — badgering, coerced/unjustified confidence, movement not grounded in facts.

Even with all five, a positive result is weak evidence. **The real validation is a human-subjects
study** (real decision-makers, matched decisions, DCIK-interview vs strong-adversarial-chat, blinded
outcome scoring, context extraction, calibration, non-badgering, and follow-up regret). That is
product/research work beyond this LLM harness.
