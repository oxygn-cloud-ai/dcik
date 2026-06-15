# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | Yes       |

## Reporting a Vulnerability

To report a security vulnerability, email dcik@oxygn.xyz. Do not open a public issue — security reports are handled confidentially.

Please include:
- A description of the vulnerability
- Steps to reproduce
- Affected versions
- Any potential mitigations you've identified

We aim to acknowledge reports within 48 hours and provide a resolution timeline within 5 business days.

## Scope

Security vulnerabilities may exist in:
- The SKILL.md orchestrator (prompt injection, model behaviour exploitation)

- The desktop manifest and distribution files (integrity, authenticity)
- The perspective library (prompt injection via perspective content)

## Out of Scope

- Vulnerabilities in third-party models, APIs, or platforms that DCIK uses at runtime
- Theoretical attacks requiring physical access to the user's machine
- Social engineering attacks against DCIK users

## Disclosure Policy

We follow coordinated disclosure. Please allow us time to fix before public disclosure. We will credit reporters who follow this policy.

## Distribution Security

DCIK is distributed via SKILL.zip (GitHub Releases) and git clone. No package registry is involved. Distribution integrity is verified via MANIFEST.json (SHA-256 hashes of all files) and commit signature verification in CI.

## Incident Response

This section defines the incident response plan for confirmed or suspected security incidents affecting DCIK.

### 1. Contact Chain

Notify the following individuals/groups in order. Escalate to the next contact if there is no response within the SLAs shown.

| Priority | Contact | Method | Response SLA |
|----------|---------|--------|--------------|
| Primary | Repository Maintainer | Email: dcik@oxygn.xyz | Immediate (within 1 hour) |
| Secondary | GitHub Security Advisory | github.com/oxygn-cloud-ai/dcik/security/advisories | Within 24 hours |
| Tertiary | Repository Admin | GitHub Security Advisory at github.com/oxygn-cloud-ai/dcik/security/advisories | Within 24 hours |

**For critical incidents (P1):** Contact the primary and secondary contacts simultaneously. Do not wait for escalation.

### 2. Containment Steps

Execute these steps immediately upon confirming an incident:

1. **Disable GitHub Actions** — Go to repository Settings > Actions > General > Disable Actions. This stops all CI/CD workflows from running, preventing automated supply-chain propagation.
2. **Suspend the GitHub repository** — If the compromise extends to repository control:
   - Contact GitHub Support to temporarily restrict access
   - Revoke all deploy keys and personal access tokens
   - Review and remove any unexpected collaborators
3. **Revoke any exposed secrets** — Rotate all secrets that may have been exposed:
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
3. **Review CI logs:**
   - GitHub Actions: Review workflow run logs for suspicious activity
   - Check for unauthorized workflow modifications
   - Verify that no workflow has exfiltrated secrets

4. **Audit access logs:**
   - GitHub audit log: Settings > Security > Audit log (requires admin access)
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
5. **Post-incident review:**
   - Document the root cause, timeline, and remediation steps
   - File a follow-up issue to track preventative measures
   - Update this incident response plan based on lessons learned
   - Conduct a team retrospective within 5 business days
