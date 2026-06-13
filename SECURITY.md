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
