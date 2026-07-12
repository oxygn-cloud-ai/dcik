# Why mental models are revered — and what our evals were missing

The paradox: Munger, Buffett, Bezos, Dalio swear by a multi-model/multi-perspective approach, yet
four fair evals show DCIK's apparatus not beating a single sharp pass. Either they're deluded, or we
measured the wrong thing. It's mostly the latter — with one caveat that partly explains the nulls.

## What mental models actually do (from the source)

Munger's latticework is **profoundly defensive — "the systematic avoidance of error"**
([sourcesofinsight](https://sourcesofinsight.com/charlie-munger-mental-models/)). Its three load-bearing
tools are *inversion* (work back from failure), *circle of competence* (know precisely where your
knowledge ends — i.e. when to PASS), and *avoiding stupidity* ("consistently not stupid" beats "very
intelligent"). The latticework's claimed magic is that, once internalised, it becomes "the **default
mode of perception**" so you "see dimensions single-discipline thinkers literally could not perceive."

Read that carefully — it names four things our evals never measured:

1. **Tail-risk / catastrophe avoidance (left tail), not average quality.** The value is in *rarely
   being stupid* across thousands of decisions. Our pairwise/recall evals measure *average* memo
   quality on a *single* well-posed question. A method that fails catastrophically less often looks
   identical on average-quality metrics but is worth vastly more over many high-stakes bets. **We were
   measuring the mean; the value is in the left tail.**
2. **Knowing when to PASS (circle of competence).** Half of Munger/Buffett's edge is *saying no* —
   recognising "too hard, unknowable, outside competence." Our evals **force an answer every time** and
   never reward correct abstention. We literally cannot see the single most-cited skill.
3. **Perceiving dimensions a NARROW thinker misses.** The models' edge is defined *against
   single-discipline specialists*. But our baseline (a frontier LLM) is **already a generalist that has
   these models latent**. The comparison where models win (generalist vs specialist) doesn't map to
   LLM-vs-LLM.
4. **Reframing / seeing non-obvious options.** The one thing that *did* surface in our test (the
   "founder secondary instead of a company sale" angle). This is the eval-visible sliver of the value.

## The caveat that partly explains the nulls (and is easy to miss)

Mental models are a **human cognitive prosthesis**: they fix a *retrieval and attention* problem —
making the right lens fire automatically in a mind that would otherwise reach for one hammer. **A
frontier LLM does not obviously have that deficit** — it already integrates law, finance, psychology,
game theory, etc., in every forward pass. So forcing it to *enumerate* 178 models may add little (or
hurt, via overthinking/false-precision, which is exactly what we observed). The latticework is
transformative *for the human who lacks the default-multidisciplinary perception*; the LLM may already
have it. **This is a real reason the apparatus underperforms — and a warning against porting a human
prosthesis to a machine that isn't missing the faculty.**

The literature also warns models can *entrench* bias and *constrain* information search
([health-systems review](https://pmc.ncbi.nlm.nih.gov/articles/PMC11044509/)) — consistent with our
finding that role-played stances bolster and forced numbers fabricate.

## What we were missing — and how to test it properly

We kept testing on the axis where models add least (average quality of one memo) against a baseline
that already embeds them. Point the eval where their value actually lives:

- **Trap / catastrophe eval (tail-risk).** Questions with a seductive-but-wrong premise or a hidden
  disqualifying flaw. Does the lens battery *catch the error a confident single pass walks into*? This
  is inversion/avoiding-stupidity — the core Munger claim.
- **Abstention eval (circle of competence).** Mix in genuinely unknowable questions. Does DCIK
  correctly say "outside competence / unknowable, here's what you'd need" where LITE-PLUS over-answers?
  Reward calibrated *refusal*.
- **Angle-discovery eval (reframing).** Does it surface the non-obvious option/action a single pass
  misses (the one thing that already showed signal)?
- **Reliability / worst-case across repeated runs**, not the mean — the left-tail claim.

## Implication for DCIK

The honest, evidence-consistent value proposition is NOT "deeper analysis of a given question." It is:
**catch the catastrophic error, know when to pass, and surface the non-obvious reframe — reliably.**
That is what mental models buy their famous users, and it is testable. If a redesigned DCIK beats
LITE-PLUS on *traps, abstention, and reframes* (even while tying on average memo quality), the
apparatus is justified — on the axis that actually matters — and the four prior nulls were measuring
the wrong thing. If it does NOT, then for an LLM the models are largely already internal, and the
honest tool is LITE-PLUS plus an explicit inversion + circle-of-competence + reframe pass.
