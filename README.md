<p align="center">
  <img src="logo.png" alt="Oxygn" width="120" />
</p>

# DCIK — Dorsolateral Cognitive Inference Kinetics

**Deep Check.** Multi-model adversarial analysis producing assessments that exceed the quality of any single-AI-prompted output — through structured iterative opposition and a growing library of analytical perspectives.

```
Claude ──► Attack ──► Improve ──► Other Model ──► Attack ──► Resolve ──► Repeat
```

## Why We Built This

A single AI prompt produces a single answer. That answer reflects one model's training distribution, one pass through the context window, one set of unexamined assumptions. It has never been challenged. It has never been forced to defend itself.

A human expert facing a consequential decision does not write one draft and call it done. They seek dissent. They ask colleagues to find the flaws. They sit with the counterarguments. They iterate.

DCIK automates that dissent. It forces assessments through adversarial cycles — model against model, perspective against perspective — until every weakness has been found, every assumption challenged, and every claim verified against current sources. The output is not what any single model would produce on its own. It is what emerges when models are forced to attack each other's work and the best arguments survive.

We built it because the cost of being wrong — on an investment, a contract, a strategy — exceeds the cost of being thorough. And because no one should have to choose between speed and depth.

## Prerequisites

DCIK runs inside Claude Code. You need one of:

| Environment | Requirement |
|-------------|-------------|
| **Claude Code CLI** | `claude` command available. [Install guide](https://docs.anthropic.com/en/docs/claude-code/overview). |
| **Claude Desktop** | macOS/Windows app with Skills support. |
| **claude.ai** | Web interface with Skills support (Organisation or Personal). |

**No API keys required.** DCIK uses whatever models are available in your Claude environment. It probes at startup and adapts — it works with a single model or multiple models.

**For manual installation only:** `git` must be available. For the npm installer: Node.js 18+.

**For the auto-improvement system:** `gh` CLI must be authenticated (`gh auth login`). This is optional — DCIK works fully without it; new perspectives are saved locally but not logged to GitHub.

## Quick Start

### Installation via SKILL.zip (Recommended)

1. Download `SKILL.zip` from the [latest release](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. **Claude Desktop / claude.ai:** Upload via Settings → Skills → Add Skill
3. **Claude Code CLI:** Unzip to `~/.claude/skills/DCIK/`
4. Invoke with `/DCIK <topic>`

> The ZIP contains SKILL.md and all 177 perspective files. You can verify its contents against the repo with `unzip -l SKILL.zip`.

### Installation via npm

```bash
npx dcik install
```

Requires Node.js 18+. Installs to `~/.claude/skills/DCIK/`. Always clones from the canonical repository and verifies commit signatures.

### Manual Installation

```bash
git clone https://github.com/oxygn-cloud-ai/dcik.git
cp -r dcik/SKILL.md ~/.claude/skills/DCIK/
cp -r dcik/perspectives ~/.claude/skills/DCIK/perspectives/
```

### First Run

```
/DCIK max "Should we enter the European market?"
```

No configuration. No onboarding. The skill executes immediately.

## What It Does

DCIK subjects any assessment, analysis, decision, or deliverable to a minimum of three adversarial review cycles. Each cycle:

1. **Applies analytical perspectives** — 177 lenses drawn from law, finance, engineering, psychology, military strategy, cognitive science, Charlie Munger's mental models, and more. Each perspective is a discrete, self-contained analytical protocol that forces the assessment to be examined from a specific angle. Mandatory perspectives include challenging the premise itself (P13) and checking for cognitive biases in the analyst (P15). A meta-perspective (P16) audits the library for missing lenses at the start and end of every run.

2. **Researches beyond the model's knowledge cutoff** — minimum 5 web searches and 3 sources that actively contradict the current assessment per cycle. Every factual claim is verified or flagged as unverified. No claim rests on stale training data.

3. **Forces adversarial review** — the primary model attacks the assessment. The revised version goes to a secondary model, which attacks it again. Where models disagree, the orchestrator resolves with deep justification. This alternating adversarial structure means no single model's blind spots survive.

4. **Iterates until convergence** — minimum 3 cycles. If new material weaknesses are still emerging, the process continues up to 10 cycles. If the last two cycles found nothing material, the assessment is genuinely robust.

5. **Self-improves** — when DCIK discovers an analytical lens not in the library, it creates a new perspective file and logs a GitHub issue. The library grows with every run.

The entire process is fully autonomous. No human input is required between cycles.

## Effort Levels

DCIK uses risk-adaptive depth — it starts with high-signal perspectives and escalates based on what it finds, not based on an arbitrary percentage of the library.

| Level | Perspectives | Behaviour |
|---|---|---|
| `min` | 5 core: premise challenge, cognitive bias check, + 3 most topic-relevant | Single pass. Quick adversarial check. |
| `med` | 5 core + counterparty analysis + 2 domain-matched | Escalates to 10 if material issues found. Two cycles. |
| `high` | 10+ (all high-signal matches for the topic domain) | Escalates to 16+ if issues persist. Three cycles minimum. |
| `max` | Full library (177+) + meta-perspective audit | Exhaustive coverage. Runs until convergence. Default for critical work. |

Invoke with `/DCIK min|med|high|max <topic>`. If no level specified, defaults to `high`.

## The Perspective Library

DCIK's analytical power comes from its perspective library — 177 discrete analytical lenses, each a self-contained protocol for examining an assessment from a specific angle. Perspectives are loaded only when relevant to the topic, keeping context usage efficient.

| ID | Perspective | Domain |
|---|---|---|
| P01 | Legal & Regulatory | Law, compliance, liability |
| P02 | Financial & Economic | Capital, incentives, value |
| P03 | Technical & Engineering | Systems, feasibility, architecture |
| P04 | Competitive & Market | Competition, positioning, dynamics |
| P05 | Ethical & Societal | Ethics, externalities, fairness |
| P06 | Historical & Precedent | Patterns, base rates, analogies |
| P07 | Stakeholder & Beneficiary | Who benefits, who bears cost |
| P08 | Counterparty & Adversary | Opposing interests, BATNA, motives |
| P09 | Jurisdictional & Geographic | Cross-border, local law, enforcement |
| P10 | Temporal & Future-Proofing | Time horizons, scenarios, resilience |
| P11 | Systems & Second-Order | Feedback loops, emergence, unintended effects |
| P12 | Information Asymmetry | Knowledge gaps, disclosure, verification |
| P13 | Challenge the Premise | Is the question itself wrong? *Mandatory every cycle.* |
| P14 | Operational & Execution | Implementation, delivery, key-person risk |
| P15 | Psychological & Cognitive Bias | Biases in the analyst and the analysis. *Mandatory every cycle.* |
| P16 | Meta-Perspective | Library coverage audit. Runs at start and end. |
| P17 | Inversion | Solve by eliminating failure paths (Munger/Jacobi) |
| P18 | Incentive Analysis | Map incentives to predict behaviour (Munger's #1 rule) |
| P19 | Base Rate Awareness | Test claims against reference-class outcomes |
| P20 | Margin of Safety | Error-bar numeric claims; find failure thresholds |
| P21 | Lollapalooza Convergence | Multi-factor convergence producing extreme outcomes |
| P22 | Agency Analysis | Principal-agent gaps in every structure |
| P23 | Survivorship Detection | Find the invisible failures; study the graveyard |
| P24 | Circle of Competence | Know the boundaries of what you don't know |

**The library grows.** When DCIK discovers a lens not covered by the existing perspectives, it creates a new perspective file and logs a GitHub issue tagged `new-perspective`. Users can add project-local perspectives for domain-specific lenses. The library is designed to compound — every run improves the tool for every future run.

**Perspective files are cacheable context units.** Each is a short, self-contained markdown file. DCIK loads only the perspectives relevant to the current topic — typically 4-7 per cycle plus mandatory P13 and P15. This keeps context windows efficient even as the library grows to dozens or hundreds of perspectives.

## Multi-Model Architecture

DCIK deliberately uses multiple AI models because different architectures catch different things. The orchestrating model handles structured reasoning and resolution. The secondary model provides independent adversarial review. If only one model is available, DCIK runs adversarial passes with explicitly different adversarial prompts — simulating the multi-model dynamic within a single model.

Model discovery happens at the start of each run. DCIK probes what is available and adapts. It never assumes a specific model is present.

## How It Works — The Full Cycle

### Phase 0: Initiation

1. Identify the assessment target — a file, topic, or question.
2. If no initial assessment exists, write one at maximum depth using all relevant perspectives. This becomes the Cycle 0 baseline. It should already be excellent — DCIK makes excellent things extraordinary.
3. Create a run directory (`DCIK_<slug>/`) with discrete files for each cycle output. This enables crash recovery — if the session dies mid-run, resume from the last completed cycle.
4. Select perspectives for Cycle 1. P13 and P15 are mandatory every cycle. P16 runs at the start (library coverage audit — are there lenses missing for this topic?).
5. Probe available models. Identify the orchestrator (primary) and the best available secondary model.

### Phase 1: Primary Model Adversarial (Cycles 1, 3, 5...)

1. Load the current assessment and selected perspectives.
2. Apply each lens systematically. For each perspective, the model asks the structured questions defined in the perspective file and records the answers.
3. Research beyond cutoff: minimum 5 web searches, minimum 3 sources that contradict or challenge the current assessment. All sources cited with URLs. Strict guardrails: never fabricate sources. If genuine contradicting sources cannot be found after extensive search, state this explicitly with the search methodology.
4. Adversarial review: find every weakness, unstated assumption, gap, overstatement, and missed angle. The assessment is wrong until proven right.
5. Write the cycle review to `DCIK_<slug>/cycle<N>_review.md` — structured by perspective, with critical weaknesses (must-fix), important gaps (should-fix), and minor improvements (could-fix).
6. Revise the assessment. Apply all must-fix and should-fix findings. Output `DCIK_<slug>/assessment_v<N+1>.md` with a change log.

### Phase 2: Secondary Model Adversarial (Cycles 2, 4, 6...)

1. Spawn the secondary model with the full current assessment, a summary of the previous cycle's findings, the applicable perspective files, and the adversarial brief.
2. The secondary model produces an independent review. Save to `DCIK_<slug>/cycle<N>_review.md`.
3. The primary model resolves any disagreements between models. For each disagreement: state both positions, analyse the basis for each, determine which is better supported by evidence and logic, and provide deep justification. Write to `DCIK_<slug>/cycle<N>_resolution.md`.
4. Revise the assessment applying valid findings and resolutions.

### Phase 3: P13 Structured Protocol

P13 (Challenge the Premise) is mandatory every cycle and follows a structured protocol:

1. **Extract every premise** — stated and unstated — that the assessment depends on.
2. **Invert each premise** — what if the opposite is true?
3. **Test the inverted world** — for premises where inversion would change the conclusion, model the alternative.
4. **Document** — which premises survived inversion, which did not, and what that means.
5. **At minimum** — identify the 3 most important premises. For each: "What if this is wrong? Does the conclusion survive?"

### Phase 4: Iterate Until Convergence

After Cycle 3, evaluate:
- Are new material findings still emerging?
- If yes, continue up to 10 cycles, adding perspectives as issues warrant.
- If the last two cycles found only minor or cosmetic issues, the process is complete.
- "No further material improvements found" is a valid outcome — but only after genuinely exhaustive search and new perspective application.

### Phase 5: Finalise

1. Write the final assessment to `DCIK_<slug>/FINAL_ASSESSMENT.md`.
2. Write the process summary to `DCIK_<slug>/PROCESS_SUMMARY.md` — cycles run, perspectives applied, key findings per cycle, resolved model disagreements, research sources, confidence levels, remaining uncertainties.
3. P16 end-of-run audit: identify at least one candidate improvement to the perspective library. Write new perspectives as `.md` files. Log GitHub issues for any new perspectives or improvements discovered.
4. The skill self-improves. The perspective library compounds.

## The Name

**DCIK — Dorsolateral Cognitive Inference Kinetics**

The dorsolateral prefrontal cortex (DLPFC) is the brain region responsible for executive function, working memory, abstract reasoning, and cognitive control — the cognitive capacities that separate rigorous analysis from superficial judgment. DCIK applies these same functions to any assessment. "Kinetics" reflects the motion-based nature of adversarial reasoning: knowledge is not discovered statically but emerges through structured opposition across cycles.

## Claude Desktop & claude.ai

### Enterprise (Organisation Skills)

For enterprise administrators deploying DCIK to all users in an organisation:

1. Download `SKILL.zip` from the [latest release](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. In Claude Desktop or claude.ai: **Customise → Skills → Organisation Skills → Upload**
3. All users in the organisation can invoke `/DCIK`

> **Note:** SKILL.zip is built from source. You can rebuild it from the repo with `zip -j SKILL.zip SKILL.md && zip -j SKILL.zip perspectives/*.md` and verify its contents match the release checksum.

### Individual (Personal Skills)

For individual Claude Desktop or claude.ai users:

1. Download `SKILL.zip` from the [latest release](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. In Claude Desktop or claude.ai: **Settings → Skills → Add Skill → Upload ZIP**
3. Invoke with `/DCIK <topic>`

> **Note:** SKILL.zip is built from source. You can rebuild it from the repo with `zip -j SKILL.zip SKILL.md && zip -j SKILL.zip perspectives/*.md` and verify its contents match the release checksum.

Alternatively, install manually:

```bash
git clone https://github.com/oxygn-cloud-ai/dcik.git
# Copy to your skills directory
cp -r dcik/SKILL.md ~/.claude/skills/DCIK/
cp -r dcik/perspectives ~/.claude/skills/DCIK/perspectives/
```

## Repository

[github.com/oxygn-cloud-ai/dcik](https://github.com/oxygn-cloud-ai/dcik) — public, MIT licensed. Issues welcome.

