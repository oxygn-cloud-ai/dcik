# Angle-hunter multi-topic test — and the authorship-bias trap I fell into

**Hypothesis:** on the axes where mental models actually add value (catch the trap / know when to
pass / reframe), does angle-hunter-DCIK beat LITE-PLUS?

## Round 1 (author-written arms): DCIK "won" 3/0 — DISCARD

Blind Codex judging of my hand-written arms: angle-hunter-DCIK beat LITE-PLUS on all three
(trap margin 5, abstention margin 5, reframe margin 4). **This result is void** — I authored both
arms and wanted DCIK to win. Post-hoc inspection confirms I strawmanned LITE-PLUS: it "noticed" the
6%/mo churn but still recommended the raise; it invented a ~55% FDA probability; it optimized the
discount tactic. Textbook confirmation bias.

## Round 2 (INDEPENDENT baseline): the win evaporates

I had Codex generate LITE-PLUS **independently** — one pass, prompted only to challenge the premise,
run a premortem, calibrate, and flag anything outside knowable competence. Independent LITE-PLUS:
- **Q1 (trap):** caught it — *"6% monthly churn… pouring fuel into a leaky bucket… I would not call
  $20M optimal… attack churn."*
- **Q2 (abstention):** abstained correctly — *"cannot responsibly be answered as posed… fake
  precision… scenario planning, not a made-up probability."*
- **Q3 (reframe):** reframed — *"New logos are not the same as good revenue… no blanket discount."*

**A properly-prompted single pass caught the trap, abstained, AND reframed — all three.** The
mental-models operations (inversion, premortem, circle-of-competence, premise-challenge) are
*promptable*, even on the axes where models are supposed to shine.

## Verdict across ALL fair tests (now 5)
1. PoC-1 (technical): FULL < LITE.
2. PoC-2 (M&A): FULL = LITE (ceiling).
3. deep-perspectives vs LITE-PLUS: deep-DCIK < LITE-PLUS (false precision).
4. angle-hunter vs *my* LITE-PLUS: DCIK won — **voided (my strawman)**.
5. angle-hunter axes vs *independent* LITE-PLUS: **independent single pass catches everything.**

**The apparatus has not beaten a properly-prompted independent single pass once.** And my one apparent
win was my own bias, which the method caught when I removed the confound — the DCIK philosophy working
on DCIK.

## The one hypothesis still standing
**Reliability, not capability.** A single pass *can* do all the operations — but does it do them
*every time*, or only when it happens to "remember"? A guaranteed checklist that forces
premise-challenge + inversion + premortem + base-rate + calibration + circle-of-competence on *every*
run may beat a single pass that is excellent on average but occasionally forgets to invert. That edge
is **reliability/variance across repeated runs**, and it is the ONLY untested claim left. It implies a
*compact operations checklist*, not 178 content perspectives.

## Honest conclusion
For a frontier LLM, mental models' value is largely already internal (they fix a *human* retrieval
deficit — see `../MENTAL-MODELS-AND-WHAT-WE-MEASURE.md`). The demonstrable, evidence-consistent DCIK is
therefore **not** 178 perspectives or multi-model debate. It is a short, sharp, *reliably-applied*
operations pass — challenge the premise, invert (what makes this catastrophic?), premortem, outside-view
base rate, calibrate, and circle-of-competence (is this even answerable?) — whose only edge over a naive
pass is that it fires **every time**. That is testable (variance across runs) and is the honest next
build.
