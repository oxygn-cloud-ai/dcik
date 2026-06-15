# Risk Assessment — DCIK Public Repository

**Date:** 16 June 2026
**Version:** v1.0.5
**Status:** Active. Re-assessed after 3-day hardening session.

---

## Executive Summary

DCIK has been public since 13 June 2026. In that time: the repository underwent adversarial security audits (chk1, chk2, DCIK self-audit), npm distribution was dropped, fabricated documentation was removed, 177 perspectives were normalized, branch protection was hardened, CI validation with behavioral red-team was added, and a signed manifest was implemented. The residual risk is **low**. The primary remaining risk is trust monoculture — one maintainer controls all merge, signing, and distribution authority.

---

## Current Risk Register

### R1 — Adversarial Understanding of Methodology

**Risk:** The 177-perspective library is public. Anyone can read the analytical playbook.
**Likelihood:** Certain. **Impact:** Low. Understanding the lenses doesn't defeat them. DCIK's output is private to the user. The methodology is a strength, not a secret.
**Status:** Accepted without mitigation.

### R2 — Trust Monoculture

**Risk:** One GitHub account controls merge authority, commit signing, and release publishing. Compromise of that single account is a full supply-chain compromise.
**Likelihood:** Low. **Impact:** Critical.
**Status:** Accepted. Mitigation (second maintainer, hardware-backed keys) requires resources not currently available. Documented honestly.

### R3 — Prompt Injection via Perspectives

**Risk:** 177 markdown files are loaded as model context. A malicious perspective could contain instructions to the model rather than analytical methodology.
**Mitigation in place:** CI validation with 20 regex patterns, Unicode homoglyph detection, multi-line proximity checks, and behavioral LLM red-team analysis on changed files. Branch protection requires signed commits and PR review. **Residual risk:** Low-medium. Architectural (code and data share the same channel).

### R4 — Distribution Integrity

**Risk:** Users download SKILL.zip from GitHub Releases or clone the repo. A compromised release would distribute malicious content.
**Mitigation in place:** Branch protection (signed commits, PR review, linear history, code owner approval). MANIFEST.json with SHA-256 hashes of all 178 distributed files. CI validates manifest staleness on every push. **Residual risk:** Low.

### R5 — Quality Perception

**Risk:** DCIK makes claims about adversarial depth. If a user gets poor results, they may publicly criticize the tool.
**Mitigation in place:** Quality claims softened from "99.99%" to "harder to be wrong about." README includes a disclaimer that output is AI-generated and not professional advice. **Residual risk:** Low.

---

## Risks Retired

| Risk | Reason |
|------|--------|
| npm supply chain | npm distribution dropped in v1.0.5. No package registry involved. |
| PII exposure | All personal references removed from source files. |
| gTLD domain sensitivity | No proprietary data in the repo. Historical context irrelevant. |
| Pre-launch checklist | All 6 mitigations completed. |
| Aspirational documentation | SECURITY.md, CODE_OF_CONDUCT.md, CONTRIBUTING.md removed — they described things that didn't exist. |

---

## Accepted Without Mitigation

- **Single maintainer.** Bus factor = 1. No succession plan.
- **No trademark registration.** DCIK is a common-law mark only.
- **No SLSA provenance.** Not applicable without a build pipeline.
- **Agent tool permission.** SKILL.md's `allowed-tools` includes `Agent` which spawns sub-agents with inherited permissions. Required for Phase 2 multi-model cycles. Tradeoff documented.
