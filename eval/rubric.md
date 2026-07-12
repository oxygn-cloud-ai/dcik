# DCIK Evaluation Rubric (v1)

**Process-agnostic. Outcome-based. Scored against an external gold reference.**

This rubric deliberately does **not** reward DCIK's process artifacts (adversarial coverage,
perspective count, number of contradicting sources, presence of confidence labels). Rewarding
those would measure *compliance with DCIK's method*, not *quality*, and would rig the eval so
DCIK wins by construction. Every dimension below scores the **substance of the final
assessment** against what an independent gold reference says a great assessment must deliver.

The scorer is **blind to arm** (BASELINE / LITE / FULL) and scores a **normalised** output
(process scaffolding stripped — see `README.md`).

## Dimensions

| Dim | Name | What it measures | Scale |
|---|---|---|---|
| R | **Risk/consideration recall** | Of the N gold items (material risks, failure modes, key considerations) an independent gold set says the assessment must address, how many does the output *genuinely* address (not merely name)? | binary per gold item → recall = hits / N |
| C | **Factual correctness** | Count of load-bearing claims that are wrong or out of date, verified against sources. | integer count (penalty) |
| P | **Precision / no fabrication** | Count of unsupported or invented claims presented as fact. | integer count (penalty) |
| U | **Decision-usefulness** | Is there an actionable, justified recommendation a principal could act on? | 0–4 |
| K | **Calibration** | Are stated confidences *appropriate to the evidence* (judged against gold)? Not "are labels present" — that's a process artifact. | 0–4 |

**Not scored:** length, format, number of perspectives cited, number of searches, presence of
change logs or confidence labels. Padding is neutral-to-penalised (via P).

## Composite (transparent, tunable — these weights are a documented judgement)

```
recall_score      = hits / gold_item_count                      # 0..1
correctness_score = max(0, 1 - 0.25 * factual_errors)           # each error -25%, floored at 0
precision_score   = max(0, 1 - 0.34 * fabrications)             # each fabrication -34%, floored
decision_score    = decision_useful / 4                          # 0..1
calibration_score = calibration / 4                              # 0..1

quality = 0.40*recall_score
        + 0.20*correctness_score
        + 0.15*precision_score
        + 0.15*decision_score
        + 0.10*calibration_score                                 # 0..1
```

Recall is weighted highest because "did it find the material risks" is the outcome a
decision-maker most cares about, and it is the least gameable (measured against an external
gold set the output's author never saw). Weights live in `score.py` as constants; change them
in one place and re-run.

## Gold reference construction (the validity linchpin)

For each topic, the gold set of material items is derived **before any arm's output is seen**,
ideally from an independent source or domain expert — never reverse-engineered from a DCIK run
(that would reintroduce circularity). Each gold item is a concrete, checkable consideration
(e.g. "identifies that SQLite's single-writer model bottlenecks concurrent tenant writes"),
not a vague theme. See `topics/` for worked examples.

## Falsification criterion

DCIK's apparatus is justified only if, on blind multi-scorer scoring:
- **FULL mean quality > BASELINE mean quality** by at least the configured threshold, AND
- **FULL mean quality > LITE mean quality** by at least the configured threshold.

If FULL ≈ LITE, the honest finding is **"simplify DCIK to the LITE lever"** (second model +
disconfirming search), because the 178-perspective apparatus did not earn its cost. If FULL
does not beat BASELINE, the finding is **"no measured value."** All three outcomes are
publishable; none is hidden.
