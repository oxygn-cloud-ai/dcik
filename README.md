<p align="center">
  <img src="logo.png" alt="Oxygn" width="100" />
</p>

<p align="center">
  <a href="https://github.com/oxygn-cloud-ai/dcik/releases"><img src="https://img.shields.io/github/v/release/oxygn-cloud-ai/dcik?color=000&label=" /></a>
  <a href="https://github.com/oxygn-cloud-ai/dcik/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-000" /></a>
  <a href="https://github.com/oxygn-cloud-ai/dcik/actions"><img src="https://img.shields.io/github/actions/workflow/status/oxygn-cloud-ai/dcik/validate.yml?branch=main&color=000&label=" /></a>
</p>

# DCIK

**Adversarial depth for consequential decisions.** A Claude Code skill that subjects any assessment to multi-model attack across 177 analytical perspectives. It doesn't produce answers — it produces answers that survived being wrong.

<br>

> *"Structured adversarial iteration produces better results than single-pass analysis, regardless of who or what performs the analysis."*

---

## Install

Requires a Claude subscription with model access. No other dependencies.

```bash
git clone https://github.com/oxygn-cloud-ai/dcik.git
mkdir -p ~/.claude/skills/DCIK
cp dcik/SKILL.md ~/.claude/skills/DCIK/
cp -r dcik/perspectives ~/.claude/skills/DCIK/perspectives/
```

Or download `SKILL.zip` from [releases](https://github.com/oxygn-cloud-ai/dcik/releases) and upload via Claude Desktop/claude.ai Settings.

## Use

```
/DCIK max path/to/assessment.md          # All 177 lenses, until convergence
/DCIK high "Is this term sheet fair?"     # 10+ lenses, 3 cycles
/DCIK min "Should we enter this market?"  # Quick adversarial check
```

---

## How It Works

| Stage | What happens |
|-------|-------------|
| **Load** | DCIK reads your assessment and selects relevant perspectives from a library of 177 analytical lenses |
| **Attack** | The primary model finds every weakness, unstated assumption, and missing piece of evidence |
| **Research** | Live web search surfaces contradicting sources beyond the model's training data |
| **Oppose** | A secondary model independently attacks the revised assessment — different architecture, different blind spots |
| **Resolve** | Where models disagree, the orchestrator resolves with evidence and structured reasoning |
| **Repeat** | Minimum 3 cycles. Continues until no material weaknesses remain. |

The output is a battle-tested assessment where every claim has been challenged, every premise inverted, and every source verified. Not "validated" — hardened.

<details>
<summary>Effort levels</summary>

| Level | Perspectives | Cycles | For |
|-------|-------------|--------|-----|
| `min` | 5 | 1 | Quick sanity check |
| `med` | 8 | 2 | Routine decisions |
| `high` | 10+ | 3+ | Significant commitments |
| `max` | 177 | Until convergence | Being wrong is expensive |

</details>

---

## The Library

177 analytical lenses from law, finance, engineering, psychology, strategy, and cognitive science. Each is a self-contained protocol — DCIK loads only the ones relevant to your topic.

| Lens | Asks |
|------|------|
| Legal & Regulatory | What laws apply? Where's the liability? |
| Counterparty & Adversary | Who benefits from your failure? What's their best move? |
| Challenge the Premise | Is the question itself wrong? |
| Cognitive Bias | What is the analyst missing about their own thinking? |
| Inversion | What would make this fail? Work backwards from failure. |
| Premortem | Assume it failed. What went wrong? |
| Multiplying by Zero | What single failure collapses everything? |
| Base Rate Awareness | What actually happened in comparable situations? |

Full listing: `perspectives/` (P0001–P0177). The library grows — when DCIK discovers a missing lens, it creates one.

---

## Example

A founder assessed whether to raise venture capital. DCIK found:

- **Incentive misalignment**: The VC's need for a billion-dollar exit diverged from the founder's goal of independence after Series A
- **Wrong base rates**: 70% of VC-backed SaaS companies in this vertical fail to reach Series B — the assessment used industry-wide averages
- **Hidden term sheet trap**: A liquidation preference would leave the founder with nothing in a moderate exit — the assessment had focused on valuation, not structure

The founder raised anyway — with a cleaner term sheet and full understanding of the tradeoffs.

---

## Security

Distributed via GitHub Releases with SHA-256 manifest verification. Repository requires signed commits and PR review. CI validates every perspective for format compliance and prompt injection patterns, including behavioral LLM red-team analysis on changed files.

[Review the source](https://github.com/oxygn-cloud-ai/dcik) before installing. This skill executes code on your machine.

---

## Disclaimer

Output is AI-generated. Not professional advice. You bear responsibility for decisions based on it. DLPFC reference is metaphorical — DCIK is an analytical framework, not a scientific instrument.

<br>
<p align="center">MIT · <a href="https://github.com/oxygn-cloud-ai/dcik">github.com/oxygn-cloud-ai/dcik</a> · v1.0.5 · single maintainer</p>
