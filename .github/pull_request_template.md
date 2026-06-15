## What

<!-- Brief, specific description. "Added PXXX perspective" or "Fixed PXX question 4 to cover..." -->

## Why

<!-- What problem does this solve? Reference an issue number if applicable. -->

## Checklist

**Check every box.** PRs with unchecked boxes will not be reviewed.

- [ ] New perspective files follow the required format: `# Perspective: [Name]`, `**ID:**`, `**Domain:**`, `**Invoke when:**`, `## Lens` (numbered, 4-12 questions), `## Default adversarial stance`
- [ ] No instructions to AI models are embedded in perspective content (no prompt injection)
- [ ] Perspective file is named `P##-name.md` matching the ID in the file
- [ ] If adding a new perspective: it does not duplicate an existing perspective
- [ ] If modifying an existing perspective: the change is explained and justified
- [ ] Version numbers updated in all locations (`SKILL.md`, `package.json`, `desktop/manifest.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`)
- [ ] Desktop manifest `files` count matches actual file count if files were added/removed
- [ ] I license this contribution under the MIT license

## Rejection is normal

DCIK is a curated library. Submissions are reviewed for quality, originality, and analytical rigour. Most are not accepted as-is. You will be told exactly why. You may revise and resubmit.
