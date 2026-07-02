# Changelog

All notable changes to DCIK are recorded here. Versions refer to the DCIK skill
version declared in `SKILL.md`. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/).

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

[1.0.9]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.9
[1.0.6]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.6
[1.0.5]: https://github.com/oxygn-cloud-ai/dcik/releases/tag/v1.0.5
