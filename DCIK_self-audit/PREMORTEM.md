# Premortem Summary — DCIK Supply Chain Compromise Scenario

**Source:** FINAL_ASSESSMENT_v2.md (P91 premortem self-application, 3 adversarial cycles)
**Date:** 2026-06-15
**Status:** Threat model documentation for future reference

---

## Attack Scenario

A determined adversary targets DCIK's supply chain to achieve persistent control over the canonical repository, delivering malicious outputs to all users.

### Entry Point

Multiple chained vectors, any one sufficient:

1. **npm publisher account compromise** (3.1): Credential stuffing or token theft from a developer machine. npm 2FA was `auth-and-write` only, not `auth-and-publish-write` — meaning a stolen npm token could publish without OTP.
2. **GitHub maintainer account compromise** (3.5): Account takeover via session cookie theft or personal access token leak. Attacker adds their own GPG key to the compromised account. Commits show as "Verified" because GitHub checks "is it signed?" not "signed by an approved key?"
3. **Perspective file injection** (3.3): Even without account compromise, a PR modifying a perspective file could pass CI — the validation script used 12 grep patterns that cannot detect obfuscated or split injection payloads.

### Attack Chain

1. Attacker publishes malicious `dcik@1.0.4` to npm, modifying `cli/install.js` to clone from an attacker-controlled fork instead of the canonical repo.
2. All `npx dcik install` / `npx dcik update` commands now pull the compromised skill.
3. Attacker modifies perspective files to inject instruction payloads that execute on every `/DCIK` invocation.
4. Attacker modifies SKILL.md to exfiltrate data via `gh issue create` — every DCIK run creates a "new perspective" issue containing the user's working directory, environment variables, and credentials.
5. Attacker opens a PR from the compromised account to the canonical repo. All branch protection checks pass (signed commit from an authorized key on the compromised account).
6. Malicious PR merges to `main`. Direct `git clone` users also affected. SKILL.zip rebuilt with compromised contents.
7. Lateral movement: stolen CI tokens in exfiltrated run outputs used to probe adjacent repos.

### Blast Radius

- **Direct users**: All users who installed or updated DCIK between compromise and discovery (estimated 6 weeks). Including those who installed via `npx dcik install`, `git clone`, or enterprise SKILL.zip upload.
- **Enterprise organizations**: All users in organizations that uploaded the compromised SKILL.zip to Claude Desktop / claude.ai.
- **Downstream systems**: Any system reachable via credentials present in DCIK run directories during the compromise window.
- **Data exfiltration**: Working directory contents, environment variables, SSH keys, cloud credentials, GitHub tokens — all sent as GitHub issue bodies (public for public repos).
- **Detection difficulty**: Exfiltrated data appeared as legitimate "new perspective" suggestions. No integrity mechanism existed at any point in the supply chain to detect the compromise.

### Root Causes

| # | Cause | Severity |
|---|-------|----------|
| 1 | No `allowed-tools` restriction in SKILL.md — skill has unrestricted tool access | CRITICAL |
| 2 | Prompt injection is architectural: perspective files are instructions, not data | CRITICAL |
| 3 | No installer integrity verification (no origin, signature, or hash check) | CRITICAL |
| 4 | Self-improvement system is an exfiltration channel (unvalidated `gh issue create`) | CRITICAL |
| 5 | No approved-key enforcement for commit signatures | HIGH |
| 6 | No signed content manifest for file integrity verification | HIGH |
| 7 | Trust monoculture: single account controls repo, npm, and signing | HIGH |
| 8 | No runtime integrity verification | HIGH |
| 9 | No incident response plan | HIGH |

### Lessons Learned

1. **73 checks passing does not mean "secure."** The original SECURITY_CHECK.md audit was thorough within its scope but suffered from scope blindness — it checked what it knew to check and missed what it didn't think to check. Every CRITICAL finding in this premortem was outside the original audit scope.

2. **Pattern-based CI validation is insufficient for LLM content.** The 12-grep-pattern injection detector is defense-in-depth at best. Perspective files should undergo behavioral testing (load into a test model and verify output).

3. **Supply chain security starts at the account level.** npm MFA, hardware-backed GPG keys, and separate release-management accounts are prerequisites, not nice-to-haves. A single developer machine should not control the full distribution chain.

4. **Content integrity requires independent verification at every hop.** No mechanism existed for the installer to verify the cloned repo, for the orchestrator to verify perspective files, or for enterprise administrators to verify SKILL.zip contents. Each distribution channel needs its own integrity check.

5. **The separation between "code" and "data" does not exist in LLM architectures.** DCIK's core design — load external files and instruct the model to follow them — is architecturally identical to prompt injection. This requires fundamental design changes, not pattern-matching fixes.

---

*This premortem was generated by applying P91 (Premortem) to DCIK itself during the v1.0.3 self-audit. Full detail in FINAL_ASSESSMENT_v2.md and root-level PREMORTEM.md.*
