<p align="center">
  <img src="logo.png" alt="Oxygn" width="120" />
</p>

# DCIK — Dorsolateral Cognitive Inference Kinetics

**Deep Check.** A Claude Code skill that subjects any assessment to structured adversarial review across 177 analytical perspectives and multiple AI models. It doesn't generate answers — it attacks them until every weakness is found.

```
You write an assessment → DCIK applies 177 lenses → Multiple models attack it → You get a harder-to-be-wrong answer
```

---

## Quick Start

DCIK runs inside Claude Code, Claude Desktop, or claude.ai. You need a Claude subscription with model access. Nothing else.

```bash
# Download the latest release
# Upload to Claude Desktop/claude.ai: Settings → Skills → Add Skill → Upload ZIP

# Or clone manually:
git clone https://github.com/oxygn-cloud-ai/dcik.git
mkdir -p ~/.claude/skills/DCIK
cp dcik/SKILL.md ~/.claude/skills/DCIK/
cp -r dcik/perspectives ~/.claude/skills/DCIK/perspectives/
```

Then invoke:
```
/DCIK min "Should we enter this market?"     # 5 perspectives, quick check
/DCIK high "Is this deal well-structured?"    # 10+ perspectives, deep review
/DCIK max path/to/assessment.md               # All 177, exhaustive
```

No configuration. No API keys. No dependencies. The skill executes immediately.

---

## What Makes It Different

A single AI prompt produces a single answer — one model, one pass, unexamined assumptions. DCIK doesn't accept that.

| Instead of | DCIK does |
|------------|-----------|
| One model's opinion | Multiple models attacking each other's work |
| Training-data-only answers | Live web research with contradicting sources |
| Unexamined assumptions | Every premise inverted and stress-tested |
| "Looks good to me" | Minimum 3 adversarial cycles, up to 10 |
| Fixed methodology | 177 perspectives, self-improving library |

The output isn't what any single model would produce. It's what emerges when every weakness has been found, every assumption challenged, and every claim verified against current sources.

---

## Effort Levels

| Level | Scope | When to use |
|-------|-------|-------------|
| `min` | 5 perspectives, 1 cycle | Quick sanity check |
| `med` | 8 perspectives, 2 cycles | Routine decisions |
| `high` | 10+ perspectives, 3+ cycles | Significant commitments |
| `max` | All 177 perspectives, until convergence | Being wrong is expensive |

Defaults to `high`. Invoke with `/DCIK <level> <topic>`.

---

## The Perspective Library

177 lenses drawn from law, finance, engineering, psychology, military strategy, cognitive science, and Charlie Munger's mental models. Each is a self-contained analytical protocol. DCIK loads only those relevant to your topic.

| # | Lens | Asks |
|---|------|------|
| P0001 | Legal & Regulatory | What laws apply? Where's the liability? |
| P0008 | Counterparty & Adversary | Who's on the other side? What's their best move? |
| P0013 | Challenge the Premise | Is the question itself wrong? |
| P0015 | Cognitive Bias | What is the analyst missing about their own thinking? |
| P0017 | Inversion | What would make this fail? |
| P0018 | Incentive Analysis | Who benefits? What are they incentivized to do? |
| P0072 | Multiplying by Zero | What single failure collapses everything? |
| P0091 | Premortem | Assume it failed. What went wrong? |
| … | 169 more | Full list: `perspectives/` |

The library grows. When DCIK discovers a missing lens, it creates one.

---

## Case Study — Bootstrap or Raise Venture Capital?

A founder wrote a 3-page assessment arguing for raising VC. They ran `/DCIK max`.

**What the founder's own analysis missed:**

- **Incentive misalignment**: The VC's need for a billion-dollar exit diverges from the founder's goal of independence after Series A. The assessment assumed shared interests.
- **Inverted premise**: Instead of "why raise?", DCIK asked "what would make bootstrapping impossible?" Customer acquisition cost exceeding revenue hadn't been modelled.
- **Wrong base rates**: 70% of VC-backed SaaS companies in this vertical fail to reach Series B. The assessment used industry-wide numbers inflated by outliers.
- **Hidden term sheet trap**: A liquidation preference would leave the founder with nothing in a moderate exit. The assessment had focused on valuation, not structure.
- **Survivorship bias**: The founder's peer group was all VC-backed successes. The dead companies weren't visible.

The founder raised anyway — with a cleaner term sheet, a bootstrapping scenario model, and a clear understanding of the tradeoffs they were making.

---

## What DCIK Doesn't Do

- It doesn't make decisions for you. It makes your decisions harder to be wrong about.
- It doesn't replace domain expertise. It stress-tests whatever expertise you bring.
- It doesn't produce a "validated" answer. It produces a battle-tested one, with residual uncertainty made explicit.

---

## Security

DCIK is distributed via GitHub Releases (SKILL.zip) and git clone. Every release includes a MANIFEST.json with SHA-256 hashes of all files. The repository has branch protection requiring signed commits and PR review. CI validates perspective content for format compliance and prompt injection patterns on every push.

You're installing a skill that can execute code on your machine. Verify before trusting: check the commit signatures, compare the MANIFEST.json hashes against your download, or clone directly from the canonical repo.

---

## Disclaimer

DCIK output is AI-generated. It may contain errors or omissions. It does not constitute professional advice — legal, financial, medical, or otherwise. You bear sole responsibility for decisions based on its output. The DLPFC reference in the name is metaphorical — DCIK is an analytical framework, not a scientific instrument.

---

## Repository

[github.com/oxygn-cloud-ai/dcik](https://github.com/oxygn-cloud-ai/dcik) — MIT licensed. Single maintainer. v1.0.5.
