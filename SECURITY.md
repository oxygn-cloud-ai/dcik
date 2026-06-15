# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | Yes       |

## Reporting a Vulnerability

To report a security vulnerability, open a GitHub issue with the label `security` or email dcik@oxygn.xyz.

Please include:
- A description of the vulnerability
- Steps to reproduce
- Affected versions
- Any potential mitigations you've identified

We aim to acknowledge reports within 48 hours and provide a resolution timeline within 5 business days.

## Scope

Security vulnerabilities may exist in:
- The SKILL.md orchestrator (prompt injection, model behaviour exploitation)
- The cli/install.js npm installer (supply chain, command injection)
- The desktop manifest and distribution files (integrity, authenticity)
- The perspective library (prompt injection via perspective content)

## Out of Scope

- Vulnerabilities in third-party models, APIs, or platforms that DCIK uses at runtime
- Theoretical attacks requiring physical access to the user's machine
- Social engineering attacks against DCIK users

## Disclosure Policy

We follow coordinated disclosure. Please allow us time to fix before public disclosure. We will credit reporters who follow this policy.

## npm Publishing Security

The `dcik` npm package is published to the npm registry. The following security measures apply:

1. **npm 2FA** must be enabled on the publishing account with `auth-and-publish-write` mode (requires OTP for every publish, not just login).
2. **Tokens** must be granular/automation tokens, not classic tokens. Classic tokens with unrestricted scope must not be used for CI or local publishing.
3. **Token rotation:** All npm tokens must be rotated every 90 days. Expired tokens must be revoked.
4. **Provenance:** When a publish workflow is added, it should use the `--provenance` flag with `npm publish` to enable npm provenance attestation, linking the published package to its CI build.
5. **Org ownership:** Verify that the `dcik` package is owned by the intended npm organization (`oxygn-cloud-ai`) and that org membership is regularly audited to remove inactive or unauthorized users.

## Incident Response

This section defines the incident response plan for confirmed or suspected security incidents affecting DCIK.

### 1. Contact Chain

Notify the following individuals/groups in order. Escalate to the next contact if there is no response within the SLAs shown.

| Priority | Contact | Method | Response SLA |
|----------|---------|--------|--------------|
| Primary | DCIK Security Team | Email: dcik-security@oxygn.xyz | Immediate (within 1 hour) |
| Secondary | Oxygn Cloud Security | Email: security@oxygn.xyz | Within 4 hours |
| Tertiary | Repository Admin | GitHub Security Advisory at github.com/oxygn-cloud-ai/dcik/security/advisories | Within 24 hours |

**For critical incidents (P1):** Contact the primary and secondary contacts simultaneously. Do not wait for escalation.

### 2. Containment Steps

Execute these steps immediately upon confirming an incident:

1. **Disable GitHub Actions** — Go to repository Settings > Actions > General > Disable Actions. This stops all CI/CD workflows from running, preventing automated supply-chain propagation.
2. **Revoke npm token** — Rotate the npm automation token used for publishing `dcik`:
   - Go to npmjs.com/settings/tokens
   - Delete the compromised token
   - Generate a new `Automation` token
   - Update the `NPM_TOKEN` secret in GitHub repository settings
3. **Unpublish the compromised npm package version** (if the incident involves an npm release):
   - `npm unpublish dcik@<compromised-version>` — removes the version from the registry
   - Note: npm only allows unpublishing versions published within the last 72 hours. For older versions, contact npm support.
4. **Suspend the GitHub repository** — If the compromise extends to repository control:
   - Contact GitHub Support to temporarily restrict access
   - Revoke all deploy keys and personal access tokens
   - Review and remove any unexpected collaborators
5. **Revoke any exposed secrets** — Rotate all secrets that may have been exposed:
   - GPG signing keys
   - GitHub personal access tokens
   - Any CI/CD secrets
   - Any service credentials referenced in the repository

### 3. Forensic Steps

After containment, gather evidence:

1. **Audit git log:**
   - `git log --all --oneline --graph` — review full branch/merge history
   - `git log --show-signature --all` — check commit signatures
   - `git diff <last-known-good>..HEAD` — review all recent changes
   - Check for unexpected tags: `git tag -l`
   - Check for unexpected branches: `git branch -a`

2. **Check npm publish history:**
   - `npm view dcik versions --json` — list all published versions
   - `npm view dcik dist-tags --json` — check the current `latest` tag
   - Review the diff between consecutive published versions

3. **Review CI logs:**
   - GitHub Actions: Review workflow run logs for suspicious activity
   - Check for unauthorized workflow modifications
   - Verify that no workflow has exfiltrated secrets

4. **Audit access logs:**
   - GitHub audit log: Settings > Security > Audit log (requires admin access)
   - npm access log: npmjs.com > Access > Package access
   - SSH/GPG key audit: Check which keys have been used recently

5. **Capture incident data:**
   - Save copies of compromised files/versions before remediation
   - Record timestamps, user accounts, and IPs involved
   - Take screenshots of relevant audit trail pages

### 4. Communication Template

When notifying users of a security incident, use this template:

```
Subject: [DCIK Security Advisory] <Brief title of the issue>

DCIK Security Advisory
ID: DCIK-SA-YYYY-NNN
Severity: <Critical/High/Medium/Low>
Date: <YYYY-MM-DD>

Summary
-------
<Brief description of the vulnerability and its impact>

Affected Versions
-----------------
- DCIK <version range affected>
- Published npm packages: <list affected versions>
- Repository references: <commits, tags, or branches>

Action Required
---------------
<What users need to do — update, revoke, rotate, etc.>

Resolution
----------
<What was done to fix the issue, including commit hashes>

Timeline
--------
- <YYYY-MM-DD HH:MM UTC> — Incident detected
- <YYYY-MM-DD HH:MM UTC> — Containment initiated
- <YYYY-MM-DD HH:MM UTC> — Fix deployed
- <YYYY-MM-DD HH:MM UTC> — Users notified

Credits
-------
<Reporter credits if applicable>
```

### 5. Recovery Steps

After the incident is contained and understood:

1. **Rotate all credentials:**
   - npm tokens
   - GitHub personal access tokens and deploy keys
   - GPG signing keys (generate a new signing subkey or revoke/expire the old key)
   - Any CI/CD secrets
   - Any third-party service tokens

2. **Rebuild from a clean commit:**
   - Identify the last known-good commit
   - `git checkout -b recovery/clean-<date> <last-known-good-commit>`
   - Verify the commit signature: `git verify-commit <commit>`
   - Apply necessary security fixes on top of the clean commit

3. **Audit and restore:**
   - Verify all CI/CD workflows are correct and not tampered
   - Run full content validation: `bash .github/scripts/validate-perspectives.sh`
   - Rebuild and verify the manifest: `bash .github/scripts/generate-manifest.sh --write`
   - Run the full test suite

4. **Republish:**
   - After recovery is verified, publish the clean version to npm:
     - Update version in `package.json` (patch bump)
     - `npm publish`
   - Update the `latest` dist-tag if needed: `npm dist-tag add dcik@<new-version> latest`
   - Push the clean branch to GitHub and create a PR for review

5. **Post-incident review:**
   - Document the root cause, timeline, and remediation steps
   - File a follow-up issue to track preventative measures
   - Update this incident response plan based on lessons learned
   - Conduct a team retrospective within 5 business days
