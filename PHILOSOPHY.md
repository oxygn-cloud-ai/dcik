# PHILOSOPHY.md — DCIK

This file is the project's compass. It records what DCIK is for, how it thinks, and which rules override convenience. Other documents (`README.md`, `SKILL.md`, `ARCHITECTURE.md`) are subordinate to this one — when they conflict with what is here, this document wins until it is itself amended.

PHILOSOPHY.md is human-owned. Only the project maintainer, with explicit deliberation, edits it.

---

## Vision

Every consequential decision deserves adversarial review. Every analysis should be tested by perspectives its author did not hold. Every claim should be challenged by evidence its author did not find.

DCIK makes this automatic. A user writes or provides an assessment. DCIK forces it through adversarial cycles — model against model, perspective against perspective, evidence against evidence — until every weakness has been found, every assumption challenged, and every claim verified against current sources. The output is not what any single model would produce on its own. It is what emerges when models are forced to attack each other's work and the best arguments survive.

The end state: a world where "I ran this through DCIK" means something specific — that an analysis has been subjected to structured adversarial review across multiple analytical lenses, multiple models, and current evidence, and has survived.

## Mission

Distribute the discipline of adversarial analysis as a self-improving skill:

- **A growing perspective library** — 177 lenses and counting, each a discrete analytical protocol drawn from law, finance, engineering, psychology, military strategy, cognitive science, and Charlie Munger's mental models.
- **A structured adversarial process** — minimum three cycles, alternating models, mandatory web research with contradiction requirements, convergence detection.
- **A self-improving architecture** — new perspectives discovered during runs become part of the library. Every run improves the tool for every future run.
- **A zero-friction install** — `npx dcik install` or a single SKILL.zip upload. No configuration. No API keys. No onboarding.

DCIK is the single source of truth for its own methodology. There is one repo, one branch, one place to land changes.

## The Core Thesis

A single AI prompt produces a single answer. That answer reflects one model's training distribution, one pass through the context window, one set of unexamined assumptions. It has never been challenged. It has never been forced to defend itself.

A human expert facing a consequential decision does not write one draft and call it done. They seek dissent. They ask colleagues to find the flaws. They sit with the counterarguments. They iterate.

DCIK automates that dissent. The thesis is not that AI is better than humans — it is that **structured adversarial iteration produces better results than single-pass analysis, regardless of who or what performs the analysis.** A human analyst who subjected their work to three cycles of adversarial review across 10+ perspectives would also produce dramatically better output. DCIK makes that process automatic, fast, and free.

## Objectives

1. **Every claim is verified or flagged as unverified.** No assertion survives without evidence. Web research extends beyond model knowledge cutoffs. Sources that contradict the assessment are actively sought, not passively encountered.

2. **Every perspective that could reasonably apply is applied.** The perspective library is designed to grow. P16 (meta-perspective) audits the library at the start and end of every run. Missing lenses become new perspectives. The library compounds.

3. **Every cycle improves the assessment.** If a cycle finds nothing material, the process has converged. If it finds material weaknesses, the next cycle escalates — more perspectives, deeper research, broader adversarial coverage. The process continues until genuinely exhaustive.

4. **The tool self-improves.** New perspectives are logged as GitHub issues and added to the library. Process improvements are captured. The skill version reflects accumulated analytical capability, not just code changes.

5. **Installation is trivial.** `npx dcik install` or upload a ZIP. No configuration required. The skill works immediately.

## Design Principles

### Adversarial iteration over single-pass analysis

The fundamental design choice. DCIK does not produce an answer — it produces the answer that survives structured opposition. This is not a feature. It is the entire thing.

Every other design choice serves this one: the perspective library provides the angles of attack; the multi-model architecture prevents single-model blind spots; the mandatory contradiction research prevents confirmation bias; the convergence detection prevents premature closure.

### Perspectives as cacheable context units

Each perspective is a short, self-contained Markdown file. It defines a lens, a set of analytical questions, and a default adversarial stance. Perspectives are loaded only when relevant to the topic — typically 4–7 per cycle plus mandatory P13 and P15.

This architecture is deliberate:
- **Context efficiency:** A 24-perspective library could consume an entire context window if loaded at once. Selective loading keeps context free for the assessment itself.
- **Composability:** Perspectives can be combined without conflict. P08 (Counterparty) asks "what would the adversary do?" while P18 (Incentive Analysis) asks "what do their incentives reward?" — different angles, same topic, no collision.
- **Growability:** New perspectives are just new `.md` files. No code changes. No schema updates. The library grows without architectural friction.

### Model diversity over model loyalty

DCIK deliberately uses multiple AI models because different architectures catch different things. The orchestrating model handles structured reasoning and resolution. The secondary model provides independent adversarial review. When only one model is available, adversarial passes use explicitly different prompts — simulating the multi-model dynamic within a single model.

No model is assumed. Model discovery happens at the start of each run. DCIK adapts to what is available.

### Risk-adaptive depth over fixed percentages

A trivial topic doesn't need 80% of a 24-perspective library. A critical topic with emerging issues needs more, not a fixed cap. DCIK starts with high-signal perspectives and escalates based on what it finds — not based on an arbitrary percentage.

This is smarter: analytical effort follows risk. When a cycle finds material issues, the next cycle adds perspectives to test the fix from more angles. When cycles find only minor issues, the process converges naturally.

### Library compounding over static capability

DCIK's perspective library is designed to grow with use. P16 audits for missing lenses. When DCIK discovers an analytical angle not covered by the existing perspectives, it creates a new perspective file and logs a GitHub issue. Users can add project-local perspectives for domain-specific lenses.

This means DCIK is a better tool after every run. The library compounds — each new perspective benefits all future assessments, not just the one that discovered it.

### Self-containment over platform dependence

DCIK works anywhere Claude Code, Claude Desktop, or claude.ai works. No external APIs. No paid services. No proprietary infrastructure. The skill is a Markdown file plus a perspective library. The npm package is a thin installer. The desktop deployment is a ZIP file.

This is deliberate: DCIK should survive platform changes, model deprecations, and infrastructure shifts. Its value is in its methodology, not its execution environment.

### Public by default

DCIK is MIT-licensed and publicly developed. The methodology is transparent. The perspective library is open. The adversarial process is documented.

This is unusual for an analytical tool — most proprietary analysis frameworks guard their methodology as competitive advantage. DCIK takes the opposite position: transparency builds trust, invites contribution, and makes the tool stronger. A counterparty who reads the perspective library knows what lenses will be applied. They cannot prevent the conclusions those lenses will reach.

## Non-Negotiables

These rules override convenience, productivity, and any single run's local judgment. They are invariants, not preferences.

1. **Never fabricate sources.** The research requirements (5 web searches, 3 contradicting sources per cycle) create pressure to find opposition. That pressure must never be resolved by invention. If genuine contradicting sources cannot be found after extensive, documented search, state this explicitly — do not create them. This rule is absolute.

2. **No single-model pass is sufficient.** A DCIK run must involve at least one adversarial review by a model other than the primary — or, if only one model is available, an explicitly adversarial pass with a different prompt. The orchestrator must be challenged. A tool that only self-reviews is not adversarial.

3. **The perspective library must grow.** P16 runs at the start and end of every DCIK run. If a material analytical lens is missing, it must be captured — as a new perspective file, a GitHub issue, or both. A run that finds no new perspectives is acceptable. A run that doesn't look is not.

4. **Convergence, not exhaustion.** DCIK stops when two consecutive cycles find nothing material — not when an arbitrary cycle count is reached. "No further material improvements found" is a valid outcome. Premature closure is not.

5. **Installation must be trivial.** The `npx dcik install` command must work on any machine with Node.js and git. The SKILL.zip must be uploadable by any Claude Desktop enterprise administrator. Installation friction is the enemy of adoption.

6. **No secrets in the repo.** The public repository contains no API keys, tokens, credentials, or proprietary data. Configuration that requires secrets (GitHub issue logging with `gh`) relies on the user's pre-existing authentication.

7. **The README is the entry point.** Every user starts there. It must be honest, specific, and technically deep. Claims must be verifiable. The explanation of how DCIK works must be complete enough that a technically sophisticated reader could implement their own version.

8. **PHILOSOPHY.md is human-owned.** Only the project maintainer, with explicit deliberation, edits this file. No automated process modifies it. No model run amends it.

---

## What this document is not

PHILOSOPHY.md is not:

- A user guide. That's `README.md`.
- A technical architecture document. That's `ARCHITECTURE.md`.
- A skill instruction set. That's `SKILL.md`.
- A change log. That's the git history.
- A risk assessment. That's `PUBLIC_RISK_ASSESSMENT.md`.

When you find yourself asking "should I add this rule to PHILOSOPHY.md?" — the test is: does breaking this rule mean DCIK is no longer what DCIK claims to be? If yes, it belongs here. If it's a sensible default that could be relaxed, it belongs in SKILL.md or ARCHITECTURE.md.
