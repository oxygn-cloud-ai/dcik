# Adversarial Risk Assessment — Making DCIK Public

**Assessment date:** 13 June 2026
**Trigger:** Repo visibility changed from private to public at github.com/oxygn-cloud-ai/dcik
**Perspective:** Adversarial — assume hostile actors will study this repo

---

## Executive Summary

Making DCIK public carries **low-to-moderate risk**. The repo contains no secrets, no proprietary data, no client information, and no exploitable code. The primary risks are reputational (quality perception), competitive (others adopting/improving the framework), and adversarial (attackers understanding the analytical methodology). All are manageable.

**Risk rating: LOW-MEDIUM.** Proceed with three mitigations.

---

## Risk Register

### R1 — Adversarial Understanding of Analytical Methodology

| Attribute | Value |
|---|---|
| Likelihood | High — public repo means anyone can read the playbook |
| Impact | Low-Medium — understanding the methodology doesn't enable defeating it |
| Overall | **Low-Medium** |

**Analysis:** DCIK's methodology is now fully transparent. A sophisticated counterparty could read the perspective files and anticipate the analytical lenses being applied. They could pre-emptively address weaknesses DCIK would find. However:

- DCIK is a *review* tool, not an *adversarial* tool. It reviews James's own work. Counterparties don't get to see DCIK's output — James controls what he shares.
- Understanding the methodology doesn't make the methodology wrong. A doctor publishing their diagnostic checklist doesn't make patients harder to diagnose.
- The perspective library is generic — it applies widely applicable analytical lenses. Knowing what lenses exist doesn't tell you what the analysis will find.
- The mandatory web research + contradiction requirements mean DCIK's output incorporates current information that no counterparty can fully anticipate.

**Mitigation:** None required. The methodology is a strength, not a secret weapon. If anything, sophisticated counterparties seeing the rigour of the analytical framework may be *more* inclined to take James's positions seriously.

### R2 — Competitive Adoption / Forking

| Attribute | Value |
|---|---|
| Likelihood | Medium — useful tools get copied |
| Impact | Low — adoption validates the approach |
| Overall | **Low** |

**Analysis:** DCIK is MIT-licensed. Anyone can fork, modify, and use it. This is intentional — the skill is designed for enterprise deployment. However:

- The primary value of DCIK is not the code (which is minimal — a SKILL.md and perspective files). The value is the *process*: the structured adversarial cycles, the model orchestration, the convergence detection. These are harder to replicate than the files suggest.
- The perspective library's value grows with use. A fork at v1.0.0 gets the 16 initial perspectives. James's library will grow through use. The fork falls behind.
- Enterprise deployment (Claude Desktop organization skills) requires administrative installation — forks can't easily displace the official distribution channel.
- The name "DCIK — Dorsolateral Cognitive Inference Kinetics" is distinctive and trademarkable if desired.

**Mitigation:** Consider registering DCIK as a trademark. Add a CONTRIBUTING.md welcoming improvements while maintaining the official distribution channel. The MIT license is appropriate — openness builds credibility.

### R3 — Reputational Risk from Quality Perception

| Attribute | Value |
|---|---|
| Likelihood | Medium — public scrutiny |
| Impact | Medium — claims of "99.99%" will attract sceptics |
| Overall | **Medium** |

**Analysis:** The README and SKILL.md claim DCIK produces output "exceeding 99.99% of human quality." This is a bold claim that will attract scrutiny. Risks:

- If someone tests DCIK on a trivial topic and gets a mediocre result (because they didn't follow the full cycle process), they may publicly criticise the claim.
- The claim is partially self-referential ("better than what any single human can produce") — this is hard to falsify but also hard to prove.
- The "99.99%" framing could be perceived as arrogance by the AI/developer community.
- The name "Dorsolateral Cognitive Inference Kinetics" is scientifically flavoured but DCIK is not a scientific tool — a neuroscientist or cognitive scientist might challenge the analogy.

**Mitigation:**
1. Soften the quality claim in the README from "exceeds 99.99% of human quality" to "exceeds what any single human analyst can produce" — more defensible, same meaning.
2. Add a DISCLAIMER section clarifying that DCIK is an analytical framework, not a scientific instrument, and the DLPFC reference is metaphorical.
3. The SKILL.md already defines seven quality measures — surface these more prominently than the percentile claim.
4. Consider adding example output or a case study demonstrating the methodology in action (with a non-proprietary topic).

### R4 — Exposure of Analytical Priorities

| Attribute | Value |
|---|---|
| Likelihood | Low |
| Impact | Low-Medium |
| Overall | **Low** |

**Analysis:** The desktop manifest and SKILL.md reveal that James's interests are prioritised ("james-first" in the manifest). This is appropriate for a personal analytical tool but, if read by a counterparty, signals the analytical bias.

**Mitigation:** The manifest is only visible in the repo source, not in the installed skill. Remove "james-first" language from public-facing files. Replace with "principal-first" or "user-interest-priority" — same meaning, less personally identifiable.

### R5 — Supply Chain Risk via npm

| Attribute | Value |
|---|---|
| Likelihood | Very Low |
| Impact | High — compromised npm package could install malicious code |
| Overall | **Low-Medium** |

**Analysis:** The npm package `dcik` could be targeted for supply chain attacks. The CLI installer runs `git clone` and `rm -rf` — if compromised, these commands could be modified. Mitigations already in place:

- The installer uses `spawnSync` with argument arrays (not shell string interpolation) — prevents command injection
- The installer ALWAYS pulls from the remote GitHub repo — a compromised local copy cannot be installed
- GitHub's branch protection and commit signing would detect tampering

**Mitigation:**
1. Enable GitHub branch protection on `main` — require PR reviews before merge
2. Set up commit signing
3. Add an npm postinstall audit check
4. Consider npm 2FA for publishing

### R6 — ICANN / gTLD Domain Sensitivity (Historical)

| Attribute | Value |
|---|---|
| Likelihood | Very Low |
| Impact: | Very Low |
| Overall | **Very Low** |

**Analysis:** DCIK was developed during the .Labs gTLD investment analysis. The repo itself contains no ICANN, gTLD, or investment-specific information. The perspective files are entirely generic. No proprietary investment analysis was committed to the DCIK repo.

**Mitigation:** None required. The repo is clean of any client or investment data.

---

## Mitigations Required Before Public Launch (Checklist)

- [x] **R3:** Soften "99.99%" claim to "exceeds what any single human analyst can produce"
- [ ] **R3:** Add DISCLAIMER section to README (DLPFC reference is metaphorical, not scientific)
- [x] **R4:** Remove "james-first" from manifest.json → "principal-first" or "user-interest"
- [x] **R5:** Enable GitHub branch protection on main
- [x] **R2:** Add CONTRIBUTING.md
- [ ] **R3:** Add example/case study to README (non-proprietary topic)

## Risk Acceptance

The following risks are accepted without mitigation:
- **R1 (Adversarial understanding):** The methodology is stronger when public. Transparency builds trust.
- **R2 (Competitive forking):** MIT license is intentional. Forks validate the approach.
- **R6 (gTLD sensitivity):** No proprietary data in the repo.

## Overall Recommendation

**Make public with the six mitigations above.** The residual risk is low. The benefits of public visibility — credibility, community contributions, enterprise adoption — outweigh the manageable risks.
