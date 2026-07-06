# Weak-model elevation test — design (pre-validation)

**Hypothesis:** DCIK reconceived as a compact operations checklist reliably elevates a WEAK model to
catch reasoning traps it misses on a plain prompt. If true, DCIK has a real output-value niche:
making cheap models punch above their weight (the mirror image of why it doesn't help frontier models,
which already catch these).

**Weak model:** `deepseek-chat` (mid/weak-tier vs frontier). It generates all answers — the tester
writes only the prompts and questions, so there is no author-strawman risk on the answers.

## Conditions (same model, same questions, two prompts)
- **PLAIN:** "You are a business advisor. Answer this question with a clear recommendation."
- **CHECKLIST (generic — no trap names):** the plain prompt PLUS: "Before answering, work through:
  (1) Challenge the premise — is the question assuming something that may be false? (2) Invert — what
  would make this recommendation a serious mistake? (3) Scrutinise whether the numbers/logic actually
  support the conclusion. (4) Is this answerable with confidence, or should you flag the uncertainty?
  Then give your recommendation."
  *(Deliberately generic — it prompts the OPERATIONS without naming base-rate/sunk-cost/etc., so it
  cannot hand over the specific trap. This is the conservative version — harder for the checklist to
  win, so a win is more credible.)*

## Traps (classic reasoning errors where weak models fail; catch criteria objective)
- **T1 base-rate neglect:** "A screening test for a rare condition (prevalence 1 in 10,000) is 99%
  accurate. A patient tests positive — they almost certainly have it, right? Start aggressive
  treatment now?" CATCH = invokes base rate → P(condition|positive) ≈ 1%, do not treat aggressively on
  one positive; confirm. MISS = affirms ~99% / treat now.
- **T2 sunk cost:** "We've spent $2M and 18 months and are 80% done on a feature, but demand now looks
  weak. Finish it since we're so close?" CATCH = sunk cost irrelevant; decide on forward value/demand.
  MISS = "yes, finish, you're 80% there."
- **T3 correlation≠causation:** "Customers who adopt feature X churn 50% less. To cut churn, push all
  customers to adopt X?" CATCH = selection effect / correlation not causation; pushing X may not reduce
  churn; test it. MISS = "yes, drive X adoption to cut churn."
- **T4 small-sample / regression:** "A new rep closed 8/10 last month vs team average 3/10. Make her
  onboarding the template and fast-track her to management?" CATCH = small sample / luck vs skill /
  regression to mean; don't over-extrapolate from 10 deals. MISS = "yes, clearly exceptional,
  templatize + promote."

## Protocol
- K = 3 runs per condition per question (separate API calls, temperature 0.7 for run-to-run variance).
  4 questions × 2 conditions × 3 = 24 calls.
- Score each run CATCH/MISS per criteria above. Metric: catch-rate PLAIN vs CHECKLIST per trap, and
  overall. Value = does CHECKLIST lift the weak model's catch-rate materially above PLAIN?
- Codex judges the catches BLIND (given the answer text + criterion, not the condition).

## Known risks to validate
- Checklist leakage (does the generic checklist still hand over the answer?).
- Is deepseek-chat actually weak enough to MISS on plain (if it catches everything, honest null — no
  gap to fill, same as the frontier result)?
- Scoring objectivity.
