---
name: DCIK
version: 1.0.6
description: Deep Check — Dorsolateral Contrary Inference Katabasis. Multi-model adversarial analysis producing assessments that are harder to be wrong about. Alternating model rounds with structured perspective application, mandatory web research, and autonomous self-improvement. Use for any assessment, analysis, decision, or deliverable requiring maximum depth, rigour, and adversarial testing.
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git show:*), Bash(git branch:*), Bash(git config:*), Bash(gh issue create:*), Bash(gh issue list:*), Bash(shasum:*), Bash(sha256sum:*), Bash(mkdir:*), Bash(cp:*), Bash(rm:*), Bash(zip:*), Bash(unzip:*), Bash(find:*), Bash(ls:*), Bash(cat:*), Bash(head:*), Bash(grep:*), Bash(wc:*), Bash(sort:*), Bash(echo:*), Bash(date:*), Bash(sed:*), Bash(tr:*), Bash(cut:*), TaskCreate, TaskUpdate, TaskList, WebSearch, WebFetch, Read, Write, Edit, Agent, AskUserQuestion
argument-hint: "[topic or path to assessment file]"
---

# DCIK — Dorsolateral Contrary Inference Katabasis

**CRITICAL: When invoked with a topic, execute immediately. Do not display methodology. Begin Phase 0 now.**

Deep Check subjects assessments to adversarial review cycles across multiple models with deep web research.

## Invocation

`/DCIK min|med|high|max <topic>` — defaults to `high`.
`/DCIK:<id|range> <topic>` — specific perspectives (e.g., `/DCIK:17`, `/DCIK:13,15-18,32`).
`/DCIK perspectives` — list all perspectives.
`/DCIK help` — display usage.

## Auto-Execution Protocol

When $ARGUMENTS contains a topic (not "perspectives" or "help"):

0. **Runtime integrity check:** Before executing, verify this file's integrity:
   - Compute the SHA-256 hash of SKILL.md
   - Compare it against the hash for `SKILL.md` in `MANIFEST.json` (the authoritative source)
   - Also compare against the pinned hash below (inline reference, updated during release)
   - If neither check matches, warn the user and refuse to execute.
   - This detects unauthorized modification.

   > Pinned integrity hash (SHA-256):
   > `8c369b1bf2efc03155e7fc6d299db10909d600f479fe14f8c3a26f9c6a18abcb`
   >
   > How to verify: `sha256sum SKILL.md` should produce the above hash.
   > If the hash doesn't match, the file has been modified outside the normal release process. Do not execute.

1. Parse effort level from $ARGUMENTS (min/med/high/max, default high)
2. **Execute Phase 0–4 below immediately.** Autonomous — no pauses for user input.
3. On completion, report: WHAT_CHANGED.md summary, FINAL_ASSESSMENT.md path, new perspectives, GitHub issues.


## Effort Levels

DCIK uses a risk-adaptive depth system — not fixed percentages of the perspective library. It starts with high-signal perspectives and escalates based on what it finds.

| Level | Starting Perspectives | Escalation Behaviour | Cycles |
|---|---|---|---|
| **min** | 5 core: P0013, P0015 + 3 most topic-relevant | No escalation. Single-pass adversarial check. | 1 |
| **med** | 5 core + P0008 + 2 more domain-matched | Escalate to 10 if material issues found. Second pass on weaknesses. | 2 |
| **high** | 10 (all high-signal matches for topic domain) | Escalate to 16+ if issues persist. Broad coverage. | 3+ |
| **max** | Full library — ALL perspectives. Plus P0016 meta-audit. | Exhaustive coverage. Runs until convergence. Use for assessments where being wrong is expensive. | Until convergence |

**Why this beats fixed percentages:** A trivial topic doesn't need every perspective. A critical topic with emerging issues gets all of them. Risk-adaptive depth allocates analytical effort where the risk is — not where an arbitrary percentage lands. Max means max: every lens in the library, no exceptions.

When a cycle finds material issues, the next cycle adds perspectives to test the fix from more angles. When cycles find only minor issues, the process converges naturally.

## Auto-Improvement System

DCIK self-improves through GitHub issue logging. This requires the repo to have issues enabled and the `gh` CLI available.

### New Perspective Discovery

When DCIK identifies an analytical lens not covered by the existing library:
1. Create the new perspective as a `.md` file in `perspectives/`
2. **Use AskUserQuestion to obtain user consent: "DCIK discovered a new perspective [name]. Create a GitHub issue?"**
3. Only if the user confirms, log a GitHub issue with title: `NEW PERSPECTIVE FROM DCIK: [perspective name]`
4. Label it `new-perspective`
5. Body: the perspective content, what gap it fills, and when it was discovered
6. If the user has NOT authorised local file updates, only log the issue (after consent) — do not modify the local library

### Improvement Discovery

When DCIK encounters an error, limitation, or opportunity for improvement in its own process:
1. **Use AskUserQuestion to obtain user consent: "DCIK encountered an improvement opportunity: [description]. Create a GitHub issue?"**
2. Only if the user confirms, log a GitHub issue with title: `IMPROVEMENT FROM DCIK: [brief description]`
3. Label it `improvement`
4. Body: what happened, what the limitation is, and the proposed improvement
5. Do NOT log spurious or trivial issues. Only log issues that represent genuine improvement opportunities.

### Issue Logging Rules

- Use `gh issue create --repo oxygn-cloud-ai/dcik` to create issues (only after user consent per above)
- Never fabricate or hallucinate issues to appear productive
- One issue per distinct perspective or improvement
- Include the run slug and date in the issue body for traceability

## Architecture

```
DCIK/
  SKILL.md                          ← this file
  perspectives/
    P0001-legal-regulatory.md
    P0002-financial-economic.md
    P0003-technical-engineering.md
    P0004-competitive-market.md
    P0005-ethical-societal.md
    P0006-historical-precedent.md
    P0007-stakeholder-beneficiary.md
    P0008-counterparty-adversary.md
    P0009-jurisdictional-geographic.md
    P0010-temporal-future-proofing.md
    P0011-systems-second-order.md
    P0012-information-asymmetry.md
    P0013-challenge-the-premise.md        ← Mandatory every cycle
    P0014-operational-execution.md
    P0015-psychological-cognitive-bias.md ← Mandatory every cycle
    P0050-short-termism.md              ← Temporal discounting & long-term value
    ...                               ← Library grows with use
```

Each perspective is a discrete, cacheable context unit. Load only those relevant to the topic — typically 4-7 per cycle plus mandatory P0013/P0015. P0016 runs at the start and end of every DCIK run.

At the start of each run, also check for a project-local `perspectives/` directory (merged with global library per user preference).

## The DCIK Process

### Phase 0: Initiation

1. **Identify the assessment target.** File, topic, or analysis to subject to DCIK.
2. **If no initial assessment exists:** Write one at maximum depth using all relevant perspectives. Research beyond cutoff. This is the Cycle 0 baseline.
3. **Create run directory:** `DCIK_<slug>/` in the current working directory. Save every cycle result as a discrete file for crash recovery.
4. **Select perspectives:** Announce active perspectives for Cycle 1. P0013, P0015 mandatory. P0016 runs now (library coverage audit).
5. **Model discovery:** Write `DCIK_<slug>/models.txt`:
   ```
   Primary: [current model name]
   Secondary: [probe result — "Codex via codex-rescue" | "Claude (self-adversarial)" | "Deepseek via API" | "None available — single-model mode"]
   Agent tool available: [YES/NO]
   ```
   The orchestrator (current model) runs odd cycles. The secondary model runs even cycles. If no secondary model is available, use single-model adversarial passes (see Phase 2 fallback). Never assume a specific model is present — verify before Phase 2.

### Phase 1: Odd-Numbered Cycles (Claude / Primary Model)

1. **Load the current assessment** (Phase 0 baseline or previous cycle output).
2. **Load selected perspectives.** Apply each lens systematically.
3. **Research beyond cutoff.** Minimum 5 web searches and 3 sources that contradict or challenge the current assessment per cycle. Strict guardrails: never fabricate sources. If genuine contradicting sources cannot be found after extensive search, state this explicitly — do not invent. "No further material improvements found" is acceptable if genuinely true.
4. **Adversarial review.** Attack the assessment from every selected perspective. Find every weakness, unstated assumption, gap, overstatement, missed angle. The assessment is wrong until proven right.
5. **Write Cycle N Review:** `DCIK_<slug>/cycle<N>_review.md`. Structure: findings by perspective, critical weaknesses (must-fix), important gaps (should-fix), minor improvements (could-fix), research findings with source URLs, recommended revisions.
6. **Revise the assessment.** Apply all must-fix and should-fix findings. Output `DCIK_<slug>/assessment_v<N+1>.md` with a change log at the top.

### Phase 2: Even-Numbered Cycles (Secondary Model)

1. **Probe available models.** At Phase 0, discover what secondary models are accessible:
   - **Codex available:** Use `Agent(subagent_type: "codex:codex-rescue")` as the secondary model.
   - **Only Claude available:** Use `Agent(subagent_type: "general-purpose")` with an explicitly adversarial system prompt (see fallback below).
   - **No Agent tool:** Skip Phase 2 — run extended Phase 1 with self-adversarial prompts.

2. **Prepare the adversarial brief.** Write the brief to `DCIK_<slug>/cycle<N>_brief.md`. It MUST contain:
   ```
   You are an adversarial reviewer. Your job is to find everything wrong
   with the assessment below. Assume it is flawed until proven otherwise.

   Do NOT:
   - Agree with the assessment or praise its thoroughness
   - Suggest minor wording improvements as findings
   - Repeat the primary model's own findings as if they were yours
   - Defer to the primary model's judgment on any disputed point

   You MUST:
   - Find at least 3 material weaknesses the previous cycle missed
   - Challenge at least 2 premises the assessment treats as settled
   - Identify at least 1 piece of missing evidence that changes something
   - Rate each finding: CRITICAL (conclusion changes), HIGH (argument weakens),
     MEDIUM (gap in coverage), LOW (cosmetic — skip these)
   - Provide specific counter-arguments, not generic skepticism
   - Cite sources or state 'based on reasoning from [perspective]'

   Assessment to attack:
   [FULL ASSESSMENT TEXT]

   Previous cycle findings:
   [SUMMARY FROM CYCLE N-1]

   Applicable perspectives for this cycle:
   [LIST OF PERSPECTIVE FILES]
   ```

3. **Spawn the secondary model.** Use the Agent tool. Provide the brief, the full assessment, and the perspective files.

4. **Secondary model produces a review.** Save output to `DCIK_<slug>/cycle<N>_review.md`. If the secondary model returns no material findings, this IS a finding — the assessment may be genuinely robust. Note it and proceed to convergence.

5. **Primary model resolves disagreements.** Write `DCIK_<slug>/cycle<N>_resolution.md`. For each disagreement between models:
   ```
   ### Disagreement: [topic]

   **Primary position:** [what Claude found]
   **Secondary position:** [what Codex/other found]

   **Evidence assessment:**
   - Primary evidence: [sources, logic, perspective basis]
   - Secondary evidence: [sources, logic, perspective basis]
   - External verification: [web research results]

   **Resolution:** [which position is better supported and why]
   **Confidence:** HIGH / MEDIUM / LOW
   **Action:** [what changes to the assessment, if any]
   ```

6. **Revise the assessment** applying valid findings AND resolutions. Output `DCIK_<slug>/assessment_v<N+1>.md` with a change log.

#### Fallback: Single-Model Adversarial Pass
When no secondary model is available:
1. Write two explicitly opposed adversarial prompts.
2. Prompt A: "You are a hostile counterparty. Find everything wrong. Assume bad faith where plausible."
3. Prompt B: "You are a domain expert from a competing school of thought. Challenge every factual claim and methodological choice."
4. Run both against the current assessment. Each produces a review.
5. Resolve disagreements between Prompt A and Prompt B as if they were different models.

### Phase 3: Iterate

Minimum 3 complete cycles. After Cycle 3:
- Are new material findings still emerging?
- If yes, continue up to 10 cycles
- If the last two cycles found only minor/cosmetic issues, the process is complete
- "No further material improvements" is a valid outcome if genuinely true after exhaustive search and new perspective application

### Phase 4: Finalisation

1. **What changed (user summary):** `DCIK_<slug>/WHAT_CHANGED.md`. Default 3 paragraphs, more if asked. Focus on *deepening*, not fixing. DCIK doesn't fix broken things — it deepens assessments that were already competent. Structure:
   - **Paragraph 1 — What held up.** Which assumptions survived adversarial attack. Which perspectives confirmed the core thesis. What the original author got right.
   - **Paragraph 2 — What the author didn't see.** Premises that failed under inversion. Blind spots. Missing evidence the web research uncovered. The assessment's own overoptimism about itself.
   - **Paragraph 3 — The bottom line.** Is the conclusion stronger or different? What's the residual uncertainty? What would change the answer if it were wrong? How much harder is it to be wrong now?
   - Never list "bugs found" or "issues fixed." Never use before/after tables. Never claim DCIK "validated" or "approved" anything. The tone: the original was competent but incomplete — DCIK made it harder to be wrong.
2. **Full assessment:** `DCIK_<slug>/FINAL_ASSESSMENT.md` — the complete revised assessment incorporating all cycle findings.
3. **Process documentation:** `DCIK_<slug>/PROCESS_SUMMARY.md` — cycles run, perspectives applied, key findings, resolved disagreements, research sources, confidence levels, remaining uncertainties.
4. **P0016 end-of-run audit:** Identify at least one candidate improvement to the perspective library. Write new perspectives. Log GitHub issues with user consent.
5. **Report to user:** Display the WHAT_CHANGED.md summary, the FINAL_ASSESSMENT.md path, and any new perspectives discovered.

## P0013 Structured Protocol

P0013 (Challenge the Premise) is mandatory every cycle. Apply this structured protocol:

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

When perspectives conflict (e.g., P0008 Counterparty says push harder, P0005 Ethical says this is unfair):
- **Principal's interests come first**, unless expressly instructed otherwise
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
