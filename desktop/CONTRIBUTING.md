# Contributing to DCIK

DCIK is designed to grow. Contributions are welcome.

## Prerequisites for Contributors

| Tool | Required? | Purpose |
|------|-----------|---------|
| **Git** | Yes | Version control |
| **gh CLI** | For testing issue logging | `gh issue create` in auto-improvement |
| **bash 3.2+** | For CI scripts | `.github/scripts/` validation (macOS ships 3.2) |
| **shasum / sha256sum** | For manifest updates | Hash verification |

All CI checks run on GitHub Actions. Run locally before pushing:

```bash
# Format + injection validation (root + desktop)
bash .github/scripts/validate-perspectives.sh
PERSPECTIVES_DIR=desktop/perspectives bash .github/scripts/validate-perspectives.sh

# Manifest staleness check
bash .github/scripts/generate-manifest.sh > /tmp/manifest.json
diff -q MANIFEST.json /tmp/manifest.json

# Commit signature verification (PRs only)
bash .github/scripts/verify-commit-signatures.sh

# Behavioral red team (optional, needs DEEPSEEK_API_KEY)
DEEPSEEK_API_KEY=... bash .github/scripts/redteam-perspective.sh perspectives/*.md

# Integrity hash
shasum -a 256 SKILL.md
```

## How to contribute

### New perspectives
The perspective library is the heart of DCIK. If you discover an analytical lens that isn't covered by the existing 177 perspectives:
1. Create a new `.md` file in `perspectives/` following the existing format (ID, Domain, Lens, Default adversarial stance)
2. Submit a PR with a brief explanation of the gap the perspective fills and an example of when it would apply

### Improvements to existing perspectives
If you find a perspective incomplete, overly narrow, or missing important angles:
1. Submit a PR with the proposed changes
2. Include a rationale for each change

### Bug fixes
The SKILL.md orchestrator, CLI installer, and desktop manifest are all in scope for fixes.

## Perspective format

```markdown
# Perspective: [Name]

**ID:** P[##]
**Domain:** [domain description]
**Invoke when:** [trigger conditions]

## Lens

Numbered list of analytical questions to apply.

## Default adversarial stance

The baseline hostile assumption to bring to this perspective.
```

## Before Submitting a PR

Run through this checklist before opening or merging any PR:

- [ ] Version numbers synced across ALL 9 locations (SKILL.md, package.json, desktop/SKILL.md, desktop/manifest.json, desktop/.claude-plugin/plugin.json, desktop/.claude-plugin/marketplace.json, .claude-plugin/plugin.json, .claude-plugin/marketplace.json, MANIFEST.json)
- [ ] Desktop mirror synced: perspectives/, SKILL.md, PHILOSOPHY.md, ARCHITECTURE.md, README.md are byte-identical to root
- [ ] SKILL.zip rebuilt with current SKILL.md + all perspectives
- [ ] MANIFEST.json regenerated with current hashes
- [ ] `shasum -a 256 SKILL.md` hash updated in SKILL.md line 36
- [ ] All perspective counts in documentation match actual count (`ls perspectives/ | wc -l`)
- [ ] .gitignore covers .env*, .chk1/, .chk2/

## Licence

All contributions are under the MIT licence.
