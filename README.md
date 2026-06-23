<p align="center">
  <img src="assets/logo.png" alt="Oxygn" width="100" />
</p>

<p align="center">
  <a href="https://scorecard.dev/viewer/?uri=github.com/oxygn-cloud-ai/dcik"><img src="https://api.scorecard.dev/projects/github.com/oxygn-cloud-ai/dcik/badge" /></a>
  <a href="https://github.com/oxygn-cloud-ai/dcik/actions/workflows/validate.yml"><img src="https://github.com/oxygn-cloud-ai/dcik/actions/workflows/validate.yml/badge.svg?branch=main" /></a>
  <a href="https://github.com/oxygn-cloud-ai/dcik/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" /></a>
</p>

# DCIK — Dorsolateral Contrary Inference Katabasis

**Thinking deeply by arguing with yourself.**

A Claude Code skill that subjects any assessment to structured adversarial review across 178 analytical perspectives, web research, and multi-model iteration.

<br>

> "Application of mental models and structured adversarial reviews produces better results than unstructured and top-of-mind analysis, regardless of who or what performs the analysis."

---

## Prerequisites

You need Claude Desktop, or Claude.ai or Claude Code CLI, with model access (no specific model required). DCIK will also attempt to use the models already available in your environment for adversarial reviews - but does not fail if these are not available. DCIK does not require API keys, package managers, headless runtimes, etc.

---

## Installation

### Claude Code CLI

Open a terminal and run:

```bash
git clone https://github.com/oxygn-cloud-ai/dcik.git
mkdir -p ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK
cp dcik/SKILL.md ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK/
cp -r dcik/perspectives ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK/perspectives/
cp dcik/MANIFEST.json ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK/
```

Verify the install worked:

```bash
ls ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK/
# You should see: MANIFEST.json   SKILL.md   perspectives/
ls ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/DCIK/perspectives/ | wc -l
# Should print: 178
```

Then start Claude Code and invoke `/DCIK <topic>` or ask Claude to perform a DCIK review.

See Usage section for optional run settings. 

### Claude Desktop and claude.ai

1. Go to the [latest release](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. Download `SKILL.zip`
3. Open Claude Desktop or claude.ai
4. Navigate to **Customise → Skills → Add skill → Create skill → Upload a skill**
5. Select the downloaded `SKILL.zip`
6. The skill appears in your skill list as "DCIK"
7. In any conversation, type `/DCIK <topic>` or ask Claude to perform a DCIK review.

See Usage section for optional run settings.

To verify the ZIP contents before uploading:

```bash
unzip -l SKILL.zip | grep -c 'perspectives/.*\.md$'
# Should print: 178
```

### Organisation-wide deployment — Claude Desktop or claude.ai

Administrators can deploy DCIK to every user in an organisation:

1. Go to the [latest release](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. Download `SKILL.zip`
3. Open Claude Desktop or claude.ai with administrator access
4. Navigate to **Customise → Skills → Organisation skills**
5. Click **Upload a skill**
6. Select the downloaded `SKILL.zip`
7. Confirm the deployment. Every user in the organisation can now invoke `/DCIK`

Organisation skills override personal skills with the same name. Users see DCIK in their available skills automatically. No per-user installation required.

### Rebuilding SKILL.zip from source

If you prefer to build the ZIP yourself rather than downloading a pre-built release:

```bash
git clone https://github.com/oxygn-cloud-ai/dcik.git
cd dcik
zip -r SKILL.zip SKILL.md perspectives/ LICENSE
```

The resulting `SKILL.zip` contains SKILL.md, all 178 perspective files in a `perspectives/` directory, and the MIT license. Verify the build:

```bash
unzip -l SKILL.zip | grep -c 'perspectives/.*\.md$'
# Should print: 178
```

The ZIP is also verifiable against `MANIFEST.json` in the repository, which contains SHA-256 hashes of every distributed file.

---

## Usage

```
/DCIK max path/to/assessment.md          # All 178 perspectives, runs until convergence
/DCIK high "Is this deal well-structured?"   # 10 perspectives, minimum 3 adversarial review cycles
/DCIK med "Should we hire this candidate?"    # 8 perspectives, 2 adversarial review cycles
/DCIK min "Quick check on this assumption"    # 5 perspectives, single adversarial review pass
```

If no level is specified, DCIK defaults to `high`.

---

<details>
<summary>Effort levels — full details</summary>

| Level | Starting Perspectives | Cycles | Escalation |
|-------|---------------------|--------|------------|
| `min` | P0013, P0015, plus 3 topic-relevant | 1 | No escalation |
| `med` | min + P0008 + 2 domain-matched | 2 | Escalates to 10 if issues found |
| `high` | 10 high-signal matches | 3+ | Escalates to 16+ if issues persist |
| `max` | All 178 perspectives + P0016 audit | Until convergence | Full escalation |

</details>

---

## How It Works

| Stage | What happens |
|-------|-------------|
| Load | DCIK reads your assessment and selects relevant perspectives from the 178-lens library |
| Attack | The primary model applies each lens systematically, finding weaknesses and unstated assumptions |
| Research | Live web searches surface contradicting sources beyond the model's training cutoff |
| Oppose | A secondary model independently attacks the revised assessment using a different architecture, if a secondary model is available, otherwise this is performed by the primary model |
| Resolve | Where models disagree, the orchestrator resolves with evidence and structured reasoning |
| Repeat | Ideally 3 cycles depending on the level setting. |

The process applies mental models, challenges claims, inverts premises, verifies sources against current information, and performs adversarial reviews against the assessment. DCIK makes no claim about the accuracy of its output — it claims only that the output has survived structured adversarial attack.

---

## Example

A founder assessed whether to raise venture capital. They ran `/DCIK max`.

What the adversarial process surfaced:

- **Incentive misalignment**: The VC's need for a billion-dollar exit diverged from the founder's goal of independence after Series A. The original assessment assumed shared interests.
- **Wrong base rates**: 70% of VC-backed SaaS companies in this vertical fail to reach Series B. The assessment used industry-wide averages inflated by outliers.
- **Hidden term sheet trap**: A liquidation preference clause would leave the founder with nothing in a moderate exit. The assessment had focused on valuation rather than structure.

The founder raised with a cleaner term sheet, a bootstrapping scenario model, a clear understanding of the tradeoffs, and a safer arrangement.

---

## The Library

178 analytical lenses from law, finance, engineering, psychology, strategy, and cognitive science. Each perspective is a self-contained protocol loaded only when relevant (or all of them is `/DCIK max` setting is used). The count includes granular unbundled lenses (individual cognitive biases alongside the broader bias perspective, for example). This is a depth/distinctness tradeoff: granular lenses prompt more sharply, broad lenses cover more ground.

| Example Lens | Asks |
|------|------|
| Legal & Regulatory | What laws apply? Where is the liability? |
| Counterparty & Adversary | Who benefits from your failure? What is their best move? |
| Challenge the Premise | Is the question itself wrong? |
| Cognitive Bias | What is the analyst missing about their own thinking? |
| Inversion | What would make this fail? Work backwards from failure. |
| Premortem | Assume it failed. What went wrong? |
| Multiplying by Zero | What single failure collapses everything? |
| Base Rate Awareness | What actually happened in comparable situations? |

The full library is in `perspectives/` (files P0001 through P0178). The library grows with use. When DCIK discovers a missing lens during a run, it logs a Github issue (with user's permission) to identify a new perspective. 

---

## Security

DCIK is continuously checked with OpenSSF Scorecard, Semgrep (SAST), and gitleaks (secret scanning). To report a vulnerability, see [SECURITY.md](SECURITY.md).

---

## Disclaimer

DCIK output is AI-generated. It may contain errors or omissions. It does not constitute professional advice of any kind — legal, financial, medical, or otherwise. You bear sole responsibility for decisions based on its output. DCIK is an analytical framework, not an advisor and it's output is specifically and expressly repudiated as advice of any type whatsoever.

<br>
<p align="center">MIT · <a href="https://github.com/oxygn-cloud-ai/dcik">github.com/oxygn-cloud-ai/dcik</a> · v1.0.7</p>
