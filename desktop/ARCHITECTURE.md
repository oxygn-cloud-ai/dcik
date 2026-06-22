# ARCHITECTURE.md — DCIK

This document describes how DCIK is built. For *why* it is built this way, see [PHILOSOPHY.md](PHILOSOPHY.md). For the skill instruction set, see [SKILL.md](SKILL.md). For the user-facing overview, see [README.md](README.md).

---

## 1. Design Philosophy

DCIK is a **skill**, not an application. It executes within the Claude Code runtime — a Markdown instruction set that the model follows under tool restrictions declared in YAML frontmatter. There is no server, no database, no persistent process. The entire system is:

- One `SKILL.md` (the orchestrator)
- 178 perspective files in `perspectives/` (the analytical library)
- One `SKILL.zip` (bundled distribution for Claude Desktop / claude.ai upload)
- One `desktop/` directory with `manifest.json` (the Claude Desktop / claude.ai mirror)

Architectural choices that flow from the philosophy:

- **Markdown over executables.** DCIK's logic is instructions, not code. The model reads SKILL.md, follows the process, and uses its built-in tools (Read, Write, Bash, WebSearch, WebFetch, Agent) to execute. There is no compilation step, no runtime, no DSL.
- **Perspectives as discrete cacheable units.** Each perspective is a self-contained `.md` file under 2KB. DCIK loads only the perspectives relevant to the current topic — typically 4–7 per cycle. This keeps context windows efficient even as the library grows to dozens or hundreds of perspectives.
- **Risk-adaptive depth.** The effort level system (`min`/`med`/`high`/`max`) controls how many perspectives are initially loaded and how aggressively the process escalates. This is not a fixed percentage — it is a behavioural control that allocates analytical effort where risk is highest.
- **Model-agnostic orchestration.** DCIK probes available models at the start of each run. The orchestrator handles odd cycles; the best available secondary model handles even cycles. If only one model is available, adversarial passes use explicitly different prompts.
- **Self-improving through GitHub issues.** New perspectives and process improvements are logged as issues on the canonical repo. When DCIK discovers a lens not in the library, it creates the file locally and logs an issue remotely. The library compounds.
- **Distribution is a file copy.** Users download SKILL.zip or clone the repo and copy files. There is no installation step — DCIK is a Markdown skill that Claude Code reads directly. No compilation, no package manager, no runtime.

---

## 2. System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    REPO (github.com/oxygn-cloud-ai/dcik)            │
│                                                                     │
│  SKILL.md          ← Orchestrator (the skill Claude Code reads)     │
│  README.md         ← User entry point                               │
│  PHILOSOPHY.md     ← Vision, principles, non-negotiables            │
│  ARCHITECTURE.md   ← This file                                      │
│  perspectives/     ← 178 analytical lenses (P0001-P0178)                  │
│  desktop/          ← Claude Desktop / claude.ai mirror              │
│    SKILL.md        ←   Copy of orchestrator                         │
│    manifest.json   ←   Org skill manifest                           │
│    perspectives/   ←   Copy of library                              │
│  SKILL.zip         ← Bundled org skill for admin upload             │
└──────────────────────┬──────────────────────────────────────────────┘
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
    SKILL.zip upload           git clone
    (Desktop/claude.ai)        (CLI + manual)
          │                         │
          ▼                         ▼
┌─────────────────────────────────────────────────────────────────────┐
│              INSTALL TARGET (${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK/)                │
│                                                                     │
│  SKILL.md          ← The orchestrator Claude Code executes          │
│  perspectives/     ← The analytical library (perspective files)     │
└─────────────────────────────────────────────────────────────────────┘
```

DCIK installs into `${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK/`. Claude Code reads `SKILL.md` when the user types `/DCIK` and follows its instructions, restricted to the tools declared in `allowed-tools` (which is unrestricted for DCIK — it needs Read, Write, Bash, WebSearch, WebFetch, and Agent).

---

## 3. Repository Layout

```
/
├── README.md                         User-facing index, install guide, methodology
├── PHILOSOPHY.md                     Vision, mission, non-negotiables (human-owned)
├── ARCHITECTURE.md                   This file
├── PUBLIC_RISK_ASSESSMENT.md         Adversarial risk assessment of public visibility
├── SKILL.md                          Orchestrator — the skill Claude Code executes
├── package.json                      project metadata
├── .gitignore                        Standard ignores (node_modules, .DS_Store, *.zip)
├── assets/
│   └── logo.png                      Oxygn logo
├── perspectives/                     Analytical library (178 lenses, P0001-P0178)
│   ├── P0001-legal-regulatory.md
│   ├── P0002-financial-economic.md
│   ├── P0003-technical-engineering.md
│   ├── P0004-competitive-market.md
│   ├── P0005-ethical-societal.md
│   ├── P0006-historical-precedent.md
│   ├── P0007-stakeholder-beneficiary.md
│   ├── P0008-counterparty-adversary.md
│   ├── P0009-jurisdictional-geographic.md
│   ├── P0010-temporal-future-proofing.md
│   ├── P0011-systems-second-order.md
│   ├── P0012-information-asymmetry.md
│   ├── P0013-challenge-the-premise.md          (mandatory every cycle)
│   ├── P0014-operational-execution.md
│   ├── P0015-psychological-cognitive-bias.md   (mandatory every cycle)
│   ├── P0016-meta-perspective.md               (runs at start and end)
│   ├── P0017-inversion.md
│   ├── P0018-incentive-analysis.md
│   ├── P0019-base-rate-awareness.md
│   ├── P0020-margin-of-safety.md
│   ├── P0021-lollapalooza-convergence.md
│   ├── P0022-agency-analysis.md
│   ├── P0023-survivorship-detection.md
│   ├── P0024-circle-of-competence.md
│   ├── ...                               (P0025-P0178 — 154 more perspectives)
│   └── P0178-operational-reality-vs-headline-metric.md
└── desktop/
    ├── SKILL.md                      Copy of orchestrator for org skill
    ├── manifest.json                 Org skill manifest (name, files, config)
    ├── README.md                     Copy of README for the ZIP bundle
    ├── assets/
    │   └── logo.png                  Copy for ZIP bundle
    └── perspectives/                 Copy of library for ZIP bundle
        └── (178 .md files)
```

---

## 4. The Perspective Library

### 4.1 File Format

Each perspective file follows a consistent structure:

```markdown
# Perspective: [Name]

**ID:** P[##]
**Domain:** [domain description]
**Source:** [attribution — Munger, Kahneman, Clausewitz, etc.]
**Invoke when:** [trigger conditions]

## Lens

Numbered list of analytical questions. Each question forces a specific examination.

## Default adversarial stance

The baseline hostile assumption to bring to this perspective.
```

Files are kept under 2KB to minimise context consumption when loaded. The lens questions are designed to be exhaustive within their domain — a single perspective should surface every weakness visible from that angle.

### 4.2 Loading Strategy

DCIK does not load all 178 perspectives at once. Instead:

1. **Cycle 0 (baseline assessment):** Load P0013, P0015, and 3–5 perspectives most relevant to the topic domain. If the topic is an investment decision, load P0002 (Financial), P0008 (Counterparty), P0012 (Information Asymmetry), P0018 (Incentive Analysis), P0020 (Margin of Safety).
2. **Cycle 1+ (adversarial):** Load the same set plus escalation perspectives based on what the previous cycle found. If financial weaknesses were found, add P0019 (Base Rates), P0023 (Survivorship Detection), P0024 (Circle of Competence).
3. **Convergence:** When the last two cycles found nothing material, stop.

The orchestrator selects perspectives based on:
- The topic's domain classification
- The risk profile of the assessment
- The findings from previous cycles
- The effort level (`min`/`med`/`high`/`max`)

### 4.3 Perspective Categories

| Category | IDs | Purpose |
|---|---|---|
| **Mandatory** | P0013, P0015 | Every cycle. Premise challenge and cognitive bias check. |
| **Meta** | P0016 | Start and end of run. Library coverage audit. |
| **Structural** | P0001, P0002, P0003, P0004, P0009, P0014 | Domain-matched analysis. |
| **Adversarial** | P0007, P0008, P0012, P0022 | Counterparty, stakeholder, and agency analysis. |
| **Temporal** | P0006, P0010, P0017, P0019, P0023 | Time, history, base rates, and inversion. |
| **Risk/Resilience** | P0005, P0011, P0020, P0021 | Margin of safety, convergence, systems, ethics. |
| **Meta-Cognitive** | P0013, P0015, P0016, P0024 | Self-awareness, bias, competence boundaries. |
| **Behavioural** | P0018, P0022 | Incentive and agency mapping. |

---

## 5. The Cycle Engine

### 5.1 State Machine

```
INIT ──► CYCLE_1 (primary adversarial) ──► REVISE ──► CYCLE_2 (secondary adversarial) ──► RESOLVE ──► REVISE
                                                                                                              │
                                                                                                              ▼
                                                                                              ┌──── CYCLE_3 (primary adversarial) ──► ...
                                                                                              │
                                                                                              ▼
                                                                                        CONVERGED? ──► FINALISE
                                                                                              │
                                                                                              ▼ NO
                                                                                           CYCLE_4+ (escalating)
```

### 5.2 Phase Details

**Phase 0 — Initiation:**
- Identify target assessment
- Create run directory (`DCIK_<slug>/`)
- Select initial perspectives
- Probe available models
- Run P0016 (library coverage audit)

**Phase 1 — Primary Adversarial (odd cycles):**
- Load current assessment
- Load selected perspectives
- Apply each lens systematically
- Research: 5+ web searches, 3+ contradicting sources
- Write adversarial review
- Revise assessment

**Phase 2 — Secondary Adversarial (even cycles):**
- Spawn secondary model via Agent tool
- Secondary model produces independent review
- Primary model resolves disagreements with deep justification
- Revise assessment

**Phase 3 — Iterate:**
- Evaluate convergence
- Escalate perspectives if material issues found
- Continue until convergence or max cycles (10)

**Phase 4 — Finalise:**
- Write final assessment
- Write process summary
- Run P0016 end-of-run audit
- Log new perspectives/improvements as GitHub issues

### 5.3 Crash Recovery

Each cycle writes to discrete files in `DCIK_<slug>/`:
- `assessment_v<N>.md` — current version of the assessment
- `cycle<N>_review.md` — the adversarial review
- `cycle<N>_resolution.md` — model disagreement resolution (even cycles only)

If the session crashes, resume from the last completed cycle by checking which files exist. The PROCESS_SUMMARY.md is updated incrementally after each cycle.

---

## 6. Multi-Model Orchestration

### 6.1 Model Discovery

At the start of each run, DCIK probes available models:
1. Check if the `codex:codex-rescue` agent type is available
2. If not, check for other agent types that spawn alternative models
3. If only one model is available, configure adversarial passes with explicitly different prompts

### 6.2 Resolution Protocol

When primary and secondary models disagree:

1. **State both positions clearly.** No straw-manning. Each position is presented in its strongest form.
2. **Analyse the basis for each.** What evidence, logic, or perspective supports each position? What assumptions does each rely on?
3. **Determine which is better supported.** The primary model evaluates both positions against:
   - Evidence quality (primary sources > secondary sources > inference > assumption)
   - Logical coherence (internal consistency, absence of contradictions)
   - Perspective coverage (which position accounts for more relevant perspectives?)
4. **Provide deep justification.** The resolution must explain not just which position was chosen, but why the other position was rejected. The reasoning must be strong enough that a disinterested third party would agree.
5. **Write resolution.** Saved to `cycle<N>_resolution.md`.

The orchestrator model resolves disagreements — not because it is always right, but because resolution requires structured reasoning, which is the orchestrator's strength. The secondary model's role is to find what the orchestrator missed. The orchestrator's role is to evaluate those findings honestly.

---

## 7. Research System

### 7.1 Requirements

Per cycle:
- Minimum 5 web searches via `WebSearch`
- Minimum 3 distinct sources that contradict or challenge the current assessment
- All sources cited with URLs

### 7.2 Hallucination Guardrails

As cycles increase, finding genuinely new contradicting sources becomes harder. Strict rules:

1. Never fabricate sources or findings.
2. If genuine contradicting sources cannot be found after extensive, documented search: state this explicitly and explain the search methodology.
3. "No further material improvements found" is acceptable — but only after genuinely exhaustive effort.
4. Quality over quantity: one authoritative primary source beats ten low-quality results.

### 7.3 Source Verification

For each source cited:
- Distinguish primary sources (official documents, regulations, court filings, direct data) from secondary sources (analysis, commentary, news)
- Flag the credibility level: authoritative, credible, unverified, or contested
- Cross-reference against other sources where possible

---

## 8. Distribution Architecture

### 8.1 SKILL.zip Distribution (Primary)

The `SKILL.zip` file bundles SKILL.md and all 178 perspective files for one-click upload:
- Built from source: `zip -r SKILL.zip SKILL.md perspectives/`
- Uploaded via Claude Desktop / claude.ai Settings → Skills → Add Skill
- Verified against MANIFEST.json for integrity (SHA-256 hashes of every file)

### 8.2 Git Clone Distribution

The `desktop/` directory contains the organisation skill bundle:
- `SKILL.md` — copy of the orchestrator
- `manifest.json` — organisation skill manifest with file list, configuration, and metadata
- `perspectives/` — copy of the full library
- `README.md and assets/logo.png — for the ZIP bundle

The `SKILL.zip` file in the repo root is pre-built for admin upload. Enterprise administrators download it from the latest GitHub release and upload via Customise → Skills → Organisation Skills.

### 8.3 Installation Flow

```
User downloads SKILL.zip from latest release
  └──► Upload via Claude Desktop/claude.ai Settings → Skills → Add Skill
        └──► Done. User types /DCIK <topic>.

User clones repo: git clone https://github.com/oxygn-cloud-ai/dcik.git
  └──► mkdir -p ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK
        └──► cp SKILL.md perspectives/ ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK/
              └──► Done. User types /DCIK <topic>.
```

Both distribution paths converge on the same installed state: `${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK/SKILL.md` + `perspectives/`.

---

## 9. Self-Improvement Loop

### 9.1 New Perspective Discovery

When DCIK identifies an analytical lens not in the library:
1. Create the perspective as a `.md` file in `perspectives/`
2. Log a GitHub issue: `NEW PERSPECTIVE FROM DCIK: [name]`
3. Label: `new-perspective`
4. The perspective is immediately available for the current run and all future runs

### 9.2 Process Improvement

When DCIK encounters a limitation in its own process:
1. Log a GitHub issue: `IMPROVEMENT FROM DCIK: [description]`
2. Label: `improvement`
3. Only genuine improvements — no spurious or trivial issues

### 9.3 Library Compounding

The perspective library is designed to compound:
- Each new perspective benefits all future assessments
- Domain-specific perspectives (created in project-local `perspectives/` directories) can be promoted to the global library
- P0016 audits for missing lenses at the start and end of every run
- The library grows monotonically — perspectives are added, never removed (deprecated perspectives are marked as such but retained for historical runs)

---

## 10. Security Model

### 10.1 Trust Boundaries

DCIK operates entirely within the Claude Code runtime. It has:
- Read/write access to the current working directory (for run outputs)
- Read access to `${CLAUDE_CONFIG_DIR:-~/.claude}/skills/DCIK/` (the installed skill)
- Network access via WebSearch and WebFetch (for research)
- Shell access via Bash (for git operations, file management, and GitHub issue logging)
- Agent spawning capability (for secondary model adversarial passes)

### 10.2 No Persistent State

DCIK maintains no persistent state outside of run directories created in the user's working directory. The skill itself is read-only after installation. All state is in the run output files.

### 10.3 GitHub Issue Logging

Issue logging uses the `gh` CLI, which requires the user to be authenticated to GitHub. DCIK does not store or transmit credentials. If `gh` is not authenticated, issue logging is skipped — the run continues with a warning.

### 10.4 Distribution Security

- SKILL.zip contents are verified against MANIFEST.json (SHA-256 hashes)
- Git clone users get the canonical repo directly — no intermediary
- GitHub secret scanning and push protection are enabled on the repo
- Branch protection requires signed commits, PR review, and linear history

---

## 11. Versioning

DCIK uses a single version number in `SKILL.md` frontmatter (`version: 1.0.7`). The version increments when:
- New perspectives are added to the library (minor bump)
- The orchestrator process changes (minor bump)
- The file format or distribution architecture changes (major bump)
- Fixes to existing files (patch bump)

The version in `package.json` and `desktop/manifest.json` follows the same number. All 9 version locations are kept in sync.

---

## 12. Future Architecture Considerations

### 12.1 Perspective Library at Scale

As the library grows beyond 178 perspectives, the current flat directory structure may need organisation — categories, tags, or a registry file mapping perspectives to domains. For now, the 178-perspective flat structure is sufficient.

### 12.2 MCP Server

A future DCIK MCP server could expose the adversarial process as a tool callable by any MCP-compatible client, not just Claude Code. This would require the cycle engine to run server-side with API access to multiple models. The perspective library and process logic would remain the same.

### 12.3 Perspective Contribution Pipeline

As the library grows through community contributions, a review process for new perspectives may be needed — quality checks, overlap detection, and integration testing before perspectives are promoted to the global library.

### 12.4 Run Caching

For assessments that are re-run (e.g., a weekly investment review), previous cycle outputs could be cached and diffed against new research rather than re-running from scratch. This is not yet implemented.
