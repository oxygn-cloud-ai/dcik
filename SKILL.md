---
name: DCIK
version: 1.0.0
description: Deep Check — Dorsolateral Cognitive Inference Kinetics. Multi-model adversarial analysis producing output exceeding 99.99% of human quality. Alternating model rounds with structured perspective application, mandatory web research, and autonomous self-improvement. Use for any assessment, analysis, decision, or deliverable requiring maximum depth, rigour, and adversarial testing.
user-invocable: true
disable-model-invocation: false
argument-hint: "[topic or path to assessment file]"
---

# DCIK — Dorsolateral Cognitive Inference Kinetics

## Purpose

Deep Check subjects any assessment to a minimum of three adversarial review cycles, alternating between available AI models, with deep web research to extend beyond knowledge cutoffs. The output exceeds 99.99% of human quality — exhaustive, multi-perspective, adversarially tested, and researched beyond model training data.

## When to use

Invoke for any task where the cost of being wrong exceeds the cost of being thorough. Default triggers: investment decisions, legal analysis, contract review, strategic recommendations, risk assessments, deliverables requiring maximum confidence.

Invoke with `/DCIK <topic or path>`.

## Architecture

```
DCIK/
  SKILL.md                          ← this file
  perspectives/
    P01-legal-regulatory.md
    P02-financial-economic.md
    P03-technical-engineering.md
    P04-competitive-market.md
    P05-ethical-societal.md
    P06-historical-precedent.md
    P07-stakeholder-beneficiary.md
    P08-counterparty-adversary.md
    P09-jurisdictional-geographic.md
    P10-temporal-future-proofing.md
    P11-systems-second-order.md
    P12-information-asymmetry.md
    P13-challenge-the-premise.md        ← Mandatory every cycle
    P14-operational-execution.md
    P15-psychological-cognitive-bias.md ← Mandatory every cycle
    P16-meta-perspective.md             ← Library self-audit (start + end of run)
```

Each perspective is a discrete, cacheable context unit. Load only those relevant to the topic — typically 4-7 per cycle plus mandatory P13/P15. P16 runs at the start and end of every DCIK run.

At the start of each run, also check for a project-local `perspectives/` directory (merged with global library per user preference).

## The DCIK Process

### Phase 0: Initiation

1. **Identify the assessment target.** File, topic, or analysis to subject to DCIK.
2. **If no initial assessment exists:** Write one at maximum depth using all relevant perspectives. Research beyond cutoff. This is the Cycle 0 baseline.
3. **Create run directory:** `DCIK_<slug>/` in the current working directory. Save every cycle result as a discrete file for crash recovery.
4. **Select perspectives:** Announce active perspectives for Cycle 1. P13, P15 mandatory. P16 runs now (library coverage audit).
5. **Model discovery:** Identify available models (Claude Opus, Codex, Deepseek, OpenRouter, etc.). The orchestrator model runs odd cycles; the best available alternative runs even cycles. Never assume a specific model is available — probe and adapt.

### Phase 1: Odd-Numbered Cycles (Claude / Primary Model)

1. **Load the current assessment** (Phase 0 baseline or previous cycle output).
2. **Load selected perspectives.** Apply each lens systematically.
3. **Research beyond cutoff.** Minimum 5 web searches and 3 sources that contradict or challenge the current assessment per cycle. Strict guardrails: never fabricate sources. If genuine contradicting sources cannot be found after extensive search, state this explicitly — do not invent. "No further material improvements found" is acceptable if genuinely true.
4. **Adversarial review.** Attack the assessment from every selected perspective. Find every weakness, unstated assumption, gap, overstatement, missed angle. The assessment is wrong until proven right.
5. **Write Cycle N Review:** `DCIK_<slug>/cycle<N>_review.md`. Structure: findings by perspective, critical weaknesses (must-fix), important gaps (should-fix), minor improvements (could-fix), research findings with source URLs, recommended revisions.
6. **Revise the assessment.** Apply all must-fix and should-fix findings. Output `DCIK_<slug>/assessment_v<N+1>.md` with a change log at the top.

### Phase 2: Even-Numbered Cycles (Codex / Secondary Model)

1. **Spawn the secondary model** (Codex via codex-rescue agent, or best available alternative). Provide: the full current assessment, summary of previous cycle findings, applicable perspective files, and the adversarial brief.
2. **Secondary model produces a review.** Save to `DCIK_<slug>/cycle<N>_review.md`.
3. **Primary model resolves disagreements.** Where models disagree:
   - State both positions clearly
   - Analyse the basis for each
   - Determine which is better supported by evidence, logic, and perspectives
   - Provide deep justification for the choice
   - Write resolution to `DCIK_<slug>/cycle<N>_resolution.md`
4. **Revise the assessment** applying valid findings and resolutions. Output `DCIK_<slug>/assessment_v<N+1>.md`.

### Phase 3: Iterate

Minimum 3 complete cycles. After Cycle 3:
- Are new material findings still emerging?
- If yes, continue up to 10 cycles
- If the last two cycles found only minor/cosmetic issues, the process is complete
- "No further material improvements" is a valid outcome if genuinely true after exhaustive search and new perspective application

### Phase 4: Finalisation

1. **Final assessment:** `DCIK_<slug>/FINAL_ASSESSMENT.md`
2. **Process summary:** `DCIK_<slug>/PROCESS_SUMMARY.md` — cycles run, perspectives applied, key findings, resolved disagreements, research sources, confidence levels, remaining uncertainties
3. **P16 end-of-run audit:** Identify at least one candidate improvement to the perspective library (new perspective, refinement, or deprecation). Write new perspectives as `.md` files.
4. **The process is fully autonomous.** No user input required between cycles. The skill self-improves its perspective library over time.

## P13 Structured Protocol

P13 (Challenge the Premise) is mandatory every cycle. Apply this structured protocol:

1. **Extract every premise.** List every stated and unstated premise the assessment depends on.
2. **Invert each premise.** For each: what if the opposite is true? What if it's not true in the way assumed?
3. **Test the inverted world.** For premises where inversion would change the conclusion: model the alternative. What evidence would support the inverted premise?
4. **Document.** Write the results: which premises survived inversion, which did not, and what that means for the assessment.
5. **At minimum:** identify the 3 most important premises and stress-test those. For each: "What if this is wrong? Does the conclusion survive?"

## Research Requirements

Per cycle, minimum:
- **5 web searches** using WebSearch
- **3 distinct sources that contradict or challenge** the current assessment
- All sources cited with URLs

**Hallucination guardrails:** As cycles increase, finding new contradicting sources becomes harder. Strict rules:
- Never fabricate sources or findings to meet minimums
- If genuine sources cannot be found after extensive, documented search: state this explicitly and explain the search methodology
- "No further material improvements found" is an acceptable outcome — but only after genuinely exhaustive effort
- Quality over quantity: one authoritative primary source beats ten low-quality blog posts

## Perspective Priority

When perspectives conflict (e.g., P08 Counterparty says push harder, P05 Ethical says this is unfair):
- **James's interests come first**, unless expressly instructed otherwise
- Legal and commercial viability are constraints, not goals
- Fairness is not an independent priority unless the user says it is
- When in unresolvable conflict, flag the conflict and the default resolution basis

## Multi-Model Architecture

DCIK deliberately uses multiple models because different architectures catch different things. The orchestrator model resolves disagreements — not because it's always right, but because resolution requires structured reasoning.

At the start of each run, probe available models. Use whatever combination is available. If only one model is accessible, run adversarial passes with explicitly different adversarial prompts (e.g., "You are a hostile counterparty. Find everything wrong." vs "You are a domain expert. Find every factual error.").

## Crash Recovery

DCIK runs can be long. If the session crashes:
1. Check `DCIK_<slug>/` for the latest assessment version and last completed cycle
2. Resume from the last completed step
3. The PROCESS_SUMMARY.md is written incrementally — update after each cycle

## Quality Target

Seven measures, not an arbitrary percentile:
1. **Completeness:** % of knowable, relevant information incorporated
2. **Adversarial coverage:** % of plausible attack vectors tested
3. **Perspective breadth:** Distinct analytical lenses applied
4. **Update freshness:** No claims based on stale data
5. **Uncertainty calibration:** Confidence levels explicit and calibrated
6. **Reproducibility:** Different team, same process → similar conclusions
7. **Actionability:** Output enables decisions impossible without it

## Sub-commands

- `/DCIK perspectives` — list all available perspectives with descriptions
- `/DCIK help` — display usage guide
- Otherwise: `/DCIK <topic or path>` — run DCIK on the specified assessment
