#!/usr/bin/env python3
"""DCIK eval scorer — deterministic aggregation of blind, gold-referenced scores.

Reads a results JSON (schema below), computes per-arm composite quality, inter-rater
agreement (Cohen's kappa on the binary gold-recall vectors), per-arm-pair deltas with
variance and win/tie/loss, and the ablation verdict.

Stdlib only. Deterministic. Verified by `test_score.py` against a hand-computed fixture.

Results schema (see results/template.json):
{
  "run_id": "str",
  "thresholds": {"full_vs_baseline": 0.15, "full_vs_lite": 0.08},
  "topics": [
    {
      "topic_id": "str",
      "gold_items": ["g1", "g2", ...],          # the external gold reference item ids
      "arms": {
        "baseline"|"lite"|"full": {
          "scores": [                             # one entry per blind scorer
            {"scorer": "str",
             "gold_hits": ["g1", ...],            # subset of gold_items genuinely addressed
             "factual_errors": int,
             "fabrications": int,
             "decision_useful": 0..4,
             "calibration": 0..4}
          ]
        }
      }
    }
  ]
}
"""
from __future__ import annotations
import argparse, json, sys
from statistics import mean, pstdev

# Composite weights (see rubric.md). Change here, re-run everywhere.
W_RECALL, W_CORRECT, W_PRECISION, W_DECISION, W_CALIB = 0.40, 0.20, 0.15, 0.15, 0.10
ERROR_PENALTY = 0.25       # per factual error
FAB_PENALTY = 0.34         # per fabrication
ARMS = ("baseline", "lite", "full")


def composite(score: dict, gold_items: list) -> float:
    """One scorer's composite quality (0..1) for one arm on one topic.

    Validates inputs (bad data corrupts evidence, so fail loud) and clamps the result to
    [0,1]. decision_useful/calibration must be 0..4; error/fabrication counts must be >= 0.
    """
    fe, fab = score.get("factual_errors", 0), score.get("fabrications", 0)
    du, cal = score.get("decision_useful", 0), score.get("calibration", 0)
    for name, val, lo, hi in (("factual_errors", fe, 0, None), ("fabrications", fab, 0, None),
                              ("decision_useful", du, 0, 4), ("calibration", cal, 0, 4)):
        if not isinstance(val, (int, float)) or isinstance(val, bool) or val < lo \
                or (hi is not None and val > hi):
            raise ValueError(f"invalid {name}={val!r} for scorer "
                             f"{score.get('scorer','?')!r}: expected "
                             f"[{lo}, {hi if hi is not None else 'inf'}]")
    n = len(gold_items)
    hits = [g for g in score.get("gold_hits", []) if g in gold_items]
    recall = (len(set(hits)) / n) if n else 0.0
    correctness = max(0.0, 1 - ERROR_PENALTY * fe)
    precision = max(0.0, 1 - FAB_PENALTY * fab)
    q = (W_RECALL * recall + W_CORRECT * correctness + W_PRECISION * precision
         + W_DECISION * (du / 4) + W_CALIB * (cal / 4))
    return max(0.0, min(1.0, q))


def cohen_kappa(vec_a: list, vec_b: list) -> float | None:
    """Cohen's kappa for two raters over binary items (hit=1/miss=0)."""
    n = len(vec_a)
    if n == 0 or len(vec_b) != n:
        return None
    po = sum(1 for a, b in zip(vec_a, vec_b) if a == b) / n
    pa1, pb1 = sum(vec_a) / n, sum(vec_b) / n
    pe = pa1 * pb1 + (1 - pa1) * (1 - pb1)
    if pe == 1.0:
        # At least one rater has no variance (e.g. both mark everything a hit). Kappa is
        # UNDEFINED here (0/0) — returning 1.0 would falsely claim perfect reliability from
        # what is actually non-discrimination. Report undefined; callers drop it.
        return None
    return (po - pe) / (1 - pe)


def arm_quality_per_topic(topic: dict, arm: str) -> float | None:
    """Mean composite across scorers for one arm on one topic."""
    a = topic.get("arms", {}).get(arm)
    if not a or not a.get("scores"):
        return None
    gold = topic["gold_items"]
    return mean(composite(s, gold) for s in a["scores"])


def topic_kappa(topic: dict) -> float | None:
    """Kappa between the first two scorers, averaged across arms, on gold-hit vectors."""
    gold = topic["gold_items"]
    kappas = []
    for arm in ARMS:
        scores = topic.get("arms", {}).get(arm, {}).get("scores", [])
        if len(scores) < 2:
            continue
        va = [1 if g in scores[0].get("gold_hits", []) else 0 for g in gold]
        vb = [1 if g in scores[1].get("gold_hits", []) else 0 for g in gold]
        k = cohen_kappa(va, vb)
        if k is not None:
            kappas.append(k)
    return mean(kappas) if kappas else None


def pair_delta(topics: list, arm_hi: str, arm_lo: str) -> dict:
    """Per-topic quality deltas (hi - lo), aggregated."""
    deltas, wins, ties, losses = [], 0, 0, 0
    for t in topics:
        qh, ql = arm_quality_per_topic(t, arm_hi), arm_quality_per_topic(t, arm_lo)
        if qh is None or ql is None:
            continue
        d = qh - ql
        deltas.append(d)
        if d > 1e-9:
            wins += 1
        elif d < -1e-9:
            losses += 1
        else:
            ties += 1
    return {
        "n": len(deltas),
        "mean_delta": mean(deltas) if deltas else None,
        "stdev": pstdev(deltas) if len(deltas) > 1 else 0.0,
        "wins": wins, "ties": ties, "losses": losses,
    }


def verdict(full_vs_base: dict, full_vs_lite: dict, thr: dict) -> str:
    tb = thr.get("full_vs_baseline", 0.15)
    tl = thr.get("full_vs_lite", 0.08)
    mb, ml = full_vs_base["mean_delta"], full_vs_lite["mean_delta"]
    if mb is None or ml is None:
        return "INSUFFICIENT DATA — need all three arms scored on shared topics."
    if mb < tb:
        return (f"NO MEASURED VALUE — FULL beats BASELINE by only {mb:+.3f} "
                f"(threshold {tb}). The apparatus is not demonstrably better than a plain pass.")
    if ml < tl:
        return (f"SIMPLIFY TO LITE — FULL beats BASELINE ({mb:+.3f}) but does NOT meaningfully "
                f"beat LITE ({ml:+.3f} < {tl}). The 178-perspective apparatus did not earn its "
                f"cost over 'second model + disconfirming search'.")
    return (f"APPARATUS JUSTIFIED — FULL beats BASELINE by {mb:+.3f} (≥{tb}) AND beats LITE by "
            f"{ml:+.3f} (≥{tl}). The full apparatus adds value beyond the simple lever.")


def analyse(data: dict) -> dict:
    topics = data.get("topics", [])
    thr = data.get("thresholds", {})
    fvb = pair_delta(topics, "full", "baseline")
    fvl = pair_delta(topics, "full", "lite")
    lvb = pair_delta(topics, "lite", "baseline")
    kappas = [k for k in (topic_kappa(t) for t in topics) if k is not None]
    counts = [len(t.get("arms", {}).get(a, {}).get("scores", []))
              for t in topics for a in ARMS
              if t.get("arms", {}).get(a, {}).get("scores")]
    min_scorers = min(counts) if counts else 0
    max_scorers = max(counts) if counts else 0
    # within-arm scorer disagreement: stdev of composites, max across arms/topics.
    # Averaging scorers then differencing arms can hide polarised disagreement; surface it.
    disagreements = []
    for t in topics:
        for a in ARMS:
            ss = t.get("arms", {}).get(a, {}).get("scores", [])
            if len(ss) >= 2:
                disagreements.append(pstdev(composite(s, t["gold_items"]) for s in ss))
    max_disagreement = max(disagreements) if disagreements else 0.0
    missing_prov = [t.get("topic_id") for t in topics if not t.get("gold_provenance")]
    k_mean = mean(kappas) if kappas else None
    return {
        "run_id": data.get("run_id"),
        "n_topics": len(topics),
        "min_scorers_per_arm": min_scorers,
        "max_scorers_per_arm": max_scorers,
        "mean_kappa": k_mean,
        "max_scorer_disagreement": max_disagreement,
        "topics_missing_gold_provenance": missing_prov,
        "arm_means": {a: _arm_mean(topics, a) for a in ARMS},
        "full_vs_baseline": fvb,
        "full_vs_lite": fvl,
        "lite_vs_baseline": lvb,
        "verdict": verdict(fvb, fvl, thr),
        "confidence": _confidence(len(topics), min_scorers, k_mean, max_disagreement, missing_prov),
    }


def _arm_mean(topics: list, arm: str) -> float | None:
    qs = [q for q in (arm_quality_per_topic(t, arm) for t in topics) if q is not None]
    return mean(qs) if qs else None


def _confidence(n_topics: int, min_scorers: int, kappa: float | None,
                max_disagreement: float = 0.0, missing_prov=None) -> str:
    flag = ""
    if missing_prov:
        flag = (f"  FLAG: {len(missing_prov)} topic(s) lack gold_provenance — gold-set "
                f"independence unverified (circularity risk).")
    if n_topics < 8 or min_scorers < 2:
        return ("EXPLORATORY — small N and/or a single scorer on at least one arm. Directional "
                "only, not confirmatory. Confirmatory needs N≥8 topics and ≥2 blind scorers on "
                "EVERY arm." + flag)
    if kappa is not None and kappa < 0.4:
        return f"LOW — inter-rater agreement weak (kappa={kappa:.2f}); scoring is noisy." + flag
    if max_disagreement > 0.15:
        return (f"MODERATE — scorers diverge within arms (max sd={max_disagreement:.2f}); report "
                f"the spread, not just the mean." + flag)
    return ("REASONABLE for a first study; still report effect sizes and variance, not just the "
            "verdict." + flag)


def format_report(r: dict) -> str:
    L = []
    L.append(f"DCIK EVAL — run '{r['run_id']}'  ({r['n_topics']} topics, "
             f"{r['min_scorers_per_arm']}–{r['max_scorers_per_arm']} scorers/arm)")
    L.append("=" * 72)
    am = r["arm_means"]
    for a in ARMS:
        v = am[a]
        L.append(f"  {a:<9} mean quality: {v:.3f}" if v is not None else f"  {a:<9} mean quality: n/a")
    k = r["mean_kappa"]
    L.append(f"  inter-rater kappa (gold recall): {k:.2f}" if k is not None else
             "  inter-rater kappa: n/a (need ≥2 scorers, non-degenerate)")
    L.append(f"  max within-arm scorer disagreement (sd): {r['max_scorer_disagreement']:.3f}")
    if r["topics_missing_gold_provenance"]:
        L.append(f"  ⚠ gold provenance MISSING for: {', '.join(r['topics_missing_gold_provenance'])}"
                 f"  (circularity risk — gold must be frozen before outputs)")
    L.append("")
    for label, key in (("FULL vs BASELINE", "full_vs_baseline"),
                       ("FULL vs LITE", "full_vs_lite"),
                       ("LITE vs BASELINE", "lite_vs_baseline")):
        d = r[key]
        md = f"{d['mean_delta']:+.3f}" if d["mean_delta"] is not None else "n/a"
        L.append(f"  {label:<18} Δ={md}  sd={d['stdev']:.3f}  "
                 f"W/T/L={d['wins']}/{d['ties']}/{d['losses']}  (n={d['n']})")
    L.append("")
    L.append(f"VERDICT: {r['verdict']}")
    L.append(f"CONFIDENCE: {r['confidence']}")
    return "\n".join(L)


def main(argv=None):
    ap = argparse.ArgumentParser(description="Score a DCIK eval results file.")
    ap.add_argument("results", help="path to results JSON")
    ap.add_argument("--json", action="store_true", help="emit machine-readable JSON")
    args = ap.parse_args(argv)
    with open(args.results) as f:
        data = json.load(f)
    r = analyse(data)
    print(json.dumps(r, indent=2) if args.json else format_report(r))
    return 0


if __name__ == "__main__":
    sys.exit(main())
