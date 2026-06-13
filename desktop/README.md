# DCIK — Dorsolateral Cognitive Inference Kinetics

**Deep Check.** Multi-model adversarial analysis producing output that exceeds what any single human analyst can produce — through structured iterative opposition and a growing library of analytical perspectives.

```
Claude ──► Attack ──► Improve ──► Codex ──► Attack ──► Resolve ──► Repeat (3x min)
```

## What It Does

DCIK subjects any assessment, analysis, decision, or deliverable to a minimum of three adversarial review cycles, alternating between AI models, with deep web research to extend beyond knowledge cutoffs. Each cycle applies a curated set of analytical perspectives — legal, financial, ethical, competitive, psychological, and more — to find every weakness, gap, and unstated assumption.

## Architecture

```
DCIK/
  SKILL.md                          ← Orchestration engine
  perspectives/
    P01-legal-regulatory.md
    P02-financial-economic.md
    P03-technical-engineering.md
    P04-competitive-market.md
    P05-ethical-societal.md
    P06-historical-precedent.md
    P07-stakeholder-beneficiary.md
    P08-counterparty-adversary.md
    P09-jurisdictional-geographic.md
    P10-temporal-future-proofing.md
    P11-systems-second-order.md
    P12-information-asymmetry.md
    P13-challenge-the-premise.md        ← Mandatory every cycle
    P14-operational-execution.md
    P15-psychological-cognitive-bias.md ← Mandatory every cycle
    P16-meta-perspective.md             ← Library self-audit
  cli/                              ← npm package for Claude Code CLI
  desktop/                          ← SKILL.zip for Claude Desktop / claude.ai
```

Each perspective file is a discrete, cacheable context unit. DCIK loads only the perspectives relevant to the topic — typically 4–7 per cycle — plus P13 and P15 which are mandatory every cycle. P16 audits the library itself for missing lenses.

## Installation

### Claude Code CLI

```bash
npx dcik install
```

Installs DCIK as a skill at `~/.claude/skills/DCIK/`. Invoke with `/DCIK <topic>`. Always pulls from `github.com/oxygn-cloud-ai/dcik`.

### Claude Desktop / claude.ai (Enterprise)

1. Download `SKILL.zip` from [releases](https://github.com/oxygn-cloud-ai/dcik/releases/latest)
2. Claude Desktop: Customise → Skills → Organisation Skills → Upload
3. Enterprise administrator must install organisation skills

## The Name

**DCIK — Dorsolateral Cognitive Inference Kinetics**

The dorsolateral prefrontal cortex (DLPFC) is the brain region responsible for executive function, working memory, abstract reasoning, and cognitive control. DCIK applies these same functions — metaphorically — to analysis. "Kinetics" reflects the iterative, motion-based nature of adversarial reasoning: knowledge emerges through structured opposition across cycles.

> **Note:** The DLPFC reference is a conceptual metaphor, not a scientific claim. DCIK is an analytical framework, not a neuroscientific instrument.

## Quality Target

Seven measures, not an arbitrary percentile: completeness, adversarial coverage, perspective breadth, update freshness, uncertainty calibration, reproducibility, actionability.

## License

MIT. [github.com/oxygn-cloud-ai/dcik](https://github.com/oxygn-cloud-ai/dcik)
