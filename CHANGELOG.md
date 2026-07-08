# Changelog

All notable changes to DCIK are recorded here. Versions refer to the DCIK skill
version declared in `SKILL.md`. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/).

## [1.2.0] — 2026-07-08

**Adds `/decide` — the evidence-derived second tool — and corrects overclaims.**

- **New skill `/decide` (`skills/decide/`)** — the Katabasis Decision Interview. After seven honest
  evals showed the 178-perspective apparatus does not improve a frontier LLM's *answer* (the model
  already has the latticework), the demonstrable value was traced to one mechanism a single model
  cannot provide: **genuine dissent from a different mind, aimed at the human's reasoning.** `/decide`
  runs a structured human interview, then a *different* model attacks the human's reasoning and a
  *third* adjudicates whether each objection was actually answered — with anti-coercion safeguards
  (unresolved objections cap confidence; bare capitulation is flagged, not counted; endorsement is
  withheld while material objections stand). Mechanism proven live across Claude+Codex+DeepSeek
  (`skills/decide/examples/DEMO-RECORD.md`); human value pending a study (`eval/flavor1/HUMAN-STUDY.md`).
- **Honesty correction:** dropped the plugin/marketplace claim that DCIK "exceeds any single-AI-prompted
  output" — the eval evidence (`eval/`) does not support it. Descriptions now state what each tool does
  and doesn't do.
- **Measurement harness + findings** (`eval/`) — the process-agnostic eval, the seven ablation studies,
  and the mental-models research that produced this repositioning are all committed and traceable.

## [1.1.1] — 2026-07-06

**Theme: make the full run *earn its cost* — fixes for the failure modes the first eval exposed.**

- **Quantitative-claim discipline** — every hard number (rate, %, benchmark, $ figure, timeline) must be sourced in the run manifest or explicitly marked an estimate. An unsourced number is a fabrication; the first eval showed a deep run can hallucinate a figure and score *worse* than a shallow one.
- **Decision-linkage** — each applied perspective must state how its finding changes the recommendation, or be marked non-load-bearing. Breadth that doesn't move the decision no longer pads the output.
- **Coverage ratchet** — escalating perspectives must strictly ADD, never drop a consideration the baseline caught. The full run must dominate the simpler pass on coverage, not merely differ from it.
- **Eval suite + held-out methodology** (`eval/SUITE.md`) — adds a high-stakes/adversarial topic class (`acquisition-offer`), where a deep adversarial method should out-perform the simple lever, with anti-Goodhart rules (held-out topics, independent arm generation, ≥2 blind scorers, gold never reverse-engineered from DCIK).
- First eval data point published (`eval/results/poc-2026-07-06/`): on a technical lookup, the simple lever matched the full apparatus — motivating both these fixes and testing on the class where depth bites.

## [1.1.0] — 2026-07-03

**Theme: making DCIK's value provable, its rigour auditable, and its CI gates real.**

- **CI fixes (both were fail-open):** the behavioural red-team now **exits 1 on a SUSPICIOUS verdict** (previously warn-only — the injection gate never actually blocked a PR); the desktop-perspective validation step now **honours `PERSPECTIVES_DIR` in PR mode** (previously hardcoded to `perspectives/`, so `desktop/perspectives/` was never validated on PRs). Both verified with red/green tests.
- **Measurement harness (`eval/`)** — the evidence engine DCIK previously lacked. Process-agnostic, gold-referenced rubric; a **3-arm ablation** (BASELINE vs LITE "second model + disconfirming search" vs FULL) that tests whether the 178-perspective apparatus earns its cost; a deterministic scorer with Cohen's κ, scorer-disagreement, and an ablation verdict (unit-tested). Offline maintainer tooling — no runtime dependency added to the skill.
- **Perspective Contract v2** — perspectives gain `## Required output` (forces a falsifiable deliverable) and `## Falsifier`. Piloted on P0013/P0015/P0016/P0125/P0132/P0133; validator enforces the sections as a **WARN-only migration ratchet** (non-blocking; rejects vacuous/stub sections). Full migration is gated on eval evidence, not a bulk rewrite.
- **Auditable runs** — DCIK emits a `RUN_MANIFEST.json` (`eval/run-manifest.schema.json`) recording searches, contradicting sources **with the exact quoted passage**, and findings mapped to assessment versions. `eval/audit-run.sh` verifies it offline, including **entailment sampling** (fetches sampled sources and fails if the quoted passage is absent).
- Validator no longer false-fails deleted/renamed perspective files in PR mode.

## [1.0.9] — 2026-07-02

- **Perspective library at 178** — adds P0178 (operational-reality-vs-headline-metric).
- Public (non-collaborator) users can log perspectives via a graceful label fallback (#53).
- README install/verify rewrite (#52).
- CODEOWNERS added for CI and governance paths (#55).
- Completed version sync across the plugin manifests, READMEs, and the `desktop/` mirror (#56).
- **Atomic version-bump tooling** — `scripts/sync-all.sh X.Y.Z` bumps every source-of-truth location at once, and `--check` is a read-only consistency gate now enforced in CI, so a release can no longer ship a split version. New `CONTRIBUTING.md`; `ARCHITECTURE.md` versioning section corrected (#57).

_Versions 1.0.7 and 1.0.8 were internal version-sync milestones folded into the 1.0.9 release._

## [1.0.6] — 2026-06-16

- Maintenance release. See the [GitHub release](https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.6).

## [1.0.5] — 2026-06-15

- Initial public release: the DCIK skill, perspective library, and distribution artifacts. See the [GitHub release](https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.5).

[1.2.0]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.2.0
[1.1.1]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.1.1
[1.1.0]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.1.0
[1.0.9]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.9
[1.0.6]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.6
[1.0.5]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.5
