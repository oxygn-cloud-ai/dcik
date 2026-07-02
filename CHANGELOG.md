# Changelog

All notable changes to DCIK are recorded here. Versions refer to the DCIK skill
version declared in `SKILL.md`. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/).

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

[1.1.0]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.1.0
[1.0.9]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.9
[1.0.6]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.6
[1.0.5]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.5
