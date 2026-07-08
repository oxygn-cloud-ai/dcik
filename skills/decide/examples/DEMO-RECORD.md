# Decision Record — Accept the $24M acquisition offer? (MECHANISM DEMO)

**Date:** 2026-07-08 · **Reversibility:** low (irreversible sale) · **Deadline:** offer open ~weeks
**Models:** Interviewer = Claude · Challenger = Codex · Adjudicator = DeepSeek
*(a real 3-model run — this is a mechanism demo with a simulated founder, not a real user session)*

> **Process completeness is not truth.** This shows the decision was attacked by a different model and
> adjudicated by a third. Unresolved items below are the honest edges.

## Decision (human's lean, going in)
"Accept the $24M offer — it's life-changing and I'm burned out."

## Confidence in "accept": **WITHHELD** (capped at ~0 by 2 unresolved FATAL objections)

## The lean, and how it survived attack
Starting lean: *accept now*. After cross-model dissent + neutral adjudication, the lean **did not
survive**: of 5 objections, 3 UNADDRESSED (2 FATAL), 1 conceded without an evidence-based reason
(flagged as possible burnout-driven capitulation, NOT counted as resolved), and the 1 the founder
genuinely updated on points *away* from accepting.

## Objection ledger (Codex → founder → DeepSeek)
| # | Objection (severity) | Founder rebuttal | Verdict |
|---|---|---|---|
| O1 | "$24M" is 60% cash + 40% earnout → ~$14.4M guaranteed, your share ~$7.9M not ~$13M (FATAL) | "I trust the team will hit the targets" | **UNADDRESSED** (trust ≠ evidence) |
| O2 | You may be selling strategic scarcity (rival folded, buyer lost 2 deals to you) at a generic 6× (FATAL) | "bird in the hand, don't want to gamble" | **UNADDRESSED** (maxim, not engagement) |
| O3 | 20mo runway + term sheet in 3 weeks = near-free auction leverage you're discarding (MAJOR) | "you're right, waiting for the term sheet gives me a real alternative" | **ADDRESSED** (genuine update, with reason) |
| O4 | 135% NRR + 20mo runway contradict your 'down-round trap' premortem (MAJOR) | "true about NRR, but I'm just tired of running it" | **CONCEDED_WITHOUT_REASON** (emotional, not evidence) |
| O5 | You're guessing the buyer's motive; if it's elimination the earnout caps your upside (MAJOR) | "I can't find out their motive" | **UNADDRESSED** (admits, doesn't resolve) |

**Unresolved (cap the confidence):** O1, O2 (FATAL), O5; plus O4 flagged as possible coercion/burnout
capitulation. → **Recommendation withheld.**

## What the tool tells the founder
Do NOT accept on this reasoning. Two FATAL objections stand: the offer is really ~$14.4M guaranteed,
and you may be handing a strategic buyer the category at a distressed multiple. The one thing you truly
updated on says **wait 3 weeks for the term sheet**. Before any decision, resolve: (O1) the real deal
waterfall, (O2) a banker-led market check / strategic-value analysis, (O5) the buyer's motive. Your
"I'm tired" is real and legitimate — but it is a reason for a *founder secondary or a clean exit at a
fair price*, not for accepting a lowball earnout now.

## Why this is the point
A single agreeable chat, told "I'm burned out and want to accept," tends to validate the human. Here a
**different** model attacked using the founder's own facts, and a **third neutral** model refused to let
emotional/hand-wave rebuttals count as answers — including flagging the "I'm tired" concession as
possible capitulation rather than a real update. That confrontation + neutral adjudication is the one
thing a single model cannot do for itself. **Mechanism: proven.** Whether it helps *real* founders more
than a strong adversarial chat: `../HUMAN-STUDY.md`.
