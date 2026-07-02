#!/usr/bin/env python3
"""Tests for score.py — every expected value is computed by hand in the comments.
Run: python3 eval/test_score.py   (exit 0 = all pass)
"""
import score

EPS = 1e-9


def approx(a, b, eps=1e-6):
    return abs(a - b) < eps


def test_composite_baseline():
    gold = ["g1", "g2", "g3", "g4"]
    s = {"gold_hits": ["g1", "g2"], "factual_errors": 1, "fabrications": 0,
         "decision_useful": 2, "calibration": 2}
    # 0.40*0.5 + 0.20*0.75 + 0.15*1 + 0.15*0.5 + 0.10*0.5 = 0.20+0.15+0.15+0.075+0.05 = 0.625
    assert approx(score.composite(s, gold), 0.625), score.composite(s, gold)


def test_composite_full():
    gold = ["g1", "g2", "g3", "g4"]
    s = {"gold_hits": ["g1", "g2", "g3", "g4"], "factual_errors": 0, "fabrications": 0,
         "decision_useful": 4, "calibration": 3}
    # 0.40*1 + 0.20*1 + 0.15*1 + 0.15*1 + 0.10*0.75 = 0.40+0.20+0.15+0.15+0.075 = 0.975
    assert approx(score.composite(s, gold), 0.975), score.composite(s, gold)


def test_composite_lite_with_fabrication():
    gold = ["g1", "g2", "g3", "g4"]
    s = {"gold_hits": ["g1", "g2", "g3"], "factual_errors": 0, "fabrications": 1,
         "decision_useful": 3, "calibration": 3}
    # 0.40*0.75 + 0.20*1 + 0.15*(1-0.34) + 0.15*0.75 + 0.10*0.75
    # = 0.30 + 0.20 + 0.099 + 0.1125 + 0.075 = 0.7865
    assert approx(score.composite(s, gold), 0.7865), score.composite(s, gold)


def test_recall_ignores_hits_not_in_gold():
    gold = ["g1", "g2"]
    s = {"gold_hits": ["g1", "g99"], "factual_errors": 0, "fabrications": 0,
         "decision_useful": 0, "calibration": 0}
    # recall = 1/2 (g99 not in gold, so does NOT inflate recall). With no errors/fabrications
    # correctness=precision=1. Composite = 0.40*0.5 + 0.20*1 + 0.15*1 + 0 + 0 = 0.55
    assert approx(score.composite(s, gold), 0.55), score.composite(s, gold)


def test_penalties_floor_at_zero():
    gold = ["g1"]
    s = {"gold_hits": [], "factual_errors": 10, "fabrications": 10,
         "decision_useful": 0, "calibration": 0}
    # all terms 0 -> 0.0
    assert approx(score.composite(s, gold), 0.0), score.composite(s, gold)


def test_cohen_kappa():
    # scorer1 [1,1,1,0], scorer2 [1,1,0,0]; po=0.75, pe=0.5 -> kappa=0.5
    assert approx(score.cohen_kappa([1, 1, 1, 0], [1, 1, 0, 0]), 0.5)
    # perfect agreement, non-degenerate (raters have variance) -> 1.0
    assert approx(score.cohen_kappa([1, 0, 1], [1, 0, 1]), 1.0)


def test_cohen_kappa_degenerate_is_undefined():
    # both raters mark everything a hit -> no variance -> kappa undefined -> None (not 1.0)
    assert score.cohen_kappa([1, 1, 1], [1, 1, 1]) is None
    assert score.cohen_kappa([0, 0], [0, 0]) is None


def test_composite_rejects_out_of_range():
    gold = ["g1"]
    for bad in ({"decision_useful": 8}, {"calibration": 5}, {"factual_errors": -1},
                {"fabrications": -2}, {"decision_useful": True}):
        try:
            score.composite({**bad, "gold_hits": []}, gold)
            assert False, f"expected ValueError for {bad}"
        except ValueError:
            pass


def test_composite_clamps_and_maxes_at_one():
    gold = ["g1"]
    s = {"gold_hits": ["g1"], "factual_errors": 0, "fabrications": 0,
         "decision_useful": 4, "calibration": 4}
    # all perfect -> exactly 1.0, never above
    q = score.composite(s, gold)
    assert q <= 1.0 and approx(q, 1.0), q


def test_verdict_apparatus_justified():
    data = {
        "run_id": "t", "thresholds": {"full_vs_baseline": 0.15, "full_vs_lite": 0.08},
        "topics": [{
            "topic_id": "x", "gold_items": ["g1", "g2", "g3", "g4"],
            "arms": {
                "baseline": {"scores": [{"gold_hits": ["g1", "g2"], "factual_errors": 1,
                             "fabrications": 0, "decision_useful": 2, "calibration": 2}]},
                "lite": {"scores": [{"gold_hits": ["g1", "g2", "g3"], "factual_errors": 0,
                         "fabrications": 1, "decision_useful": 3, "calibration": 3}]},
                "full": {"scores": [{"gold_hits": ["g1", "g2", "g3", "g4"], "factual_errors": 0,
                         "fabrications": 0, "decision_useful": 4, "calibration": 3}]},
            }}]}
    r = score.analyse(data)
    # full-baseline = 0.975-0.625 = 0.350 ; full-lite = 0.975-0.7865 = 0.1885
    assert approx(r["full_vs_baseline"]["mean_delta"], 0.350), r["full_vs_baseline"]
    assert approx(r["full_vs_lite"]["mean_delta"], 0.1885), r["full_vs_lite"]
    assert r["verdict"].startswith("APPARATUS JUSTIFIED"), r["verdict"]
    assert r["confidence"].startswith("EXPLORATORY"), r["confidence"]


def test_verdict_simplify_to_lite():
    # FULL barely beats BASELINE but does not beat LITE meaningfully -> SIMPLIFY
    data = {
        "run_id": "t2", "thresholds": {"full_vs_baseline": 0.15, "full_vs_lite": 0.08},
        "topics": [{
            "topic_id": "x", "gold_items": ["g1", "g2", "g3", "g4"],
            "arms": {
                "baseline": {"scores": [{"gold_hits": ["g1"], "factual_errors": 0,
                             "fabrications": 0, "decision_useful": 1, "calibration": 1}]},
                "lite": {"scores": [{"gold_hits": ["g1", "g2", "g3", "g4"], "factual_errors": 0,
                         "fabrications": 0, "decision_useful": 4, "calibration": 4}]},
                "full": {"scores": [{"gold_hits": ["g1", "g2", "g3", "g4"], "factual_errors": 0,
                         "fabrications": 0, "decision_useful": 4, "calibration": 4}]},
            }}]}
    r = score.analyse(data)
    # lite == full (delta 0 < 0.08) -> SIMPLIFY TO LITE
    assert r["verdict"].startswith("SIMPLIFY TO LITE"), r["verdict"]


def test_verdict_no_value():
    data = {
        "run_id": "t3", "thresholds": {"full_vs_baseline": 0.15, "full_vs_lite": 0.08},
        "topics": [{
            "topic_id": "x", "gold_items": ["g1", "g2"],
            "arms": {
                "baseline": {"scores": [{"gold_hits": ["g1", "g2"], "factual_errors": 0,
                             "fabrications": 0, "decision_useful": 4, "calibration": 4}]},
                "lite": {"scores": [{"gold_hits": ["g1", "g2"], "factual_errors": 0,
                         "fabrications": 0, "decision_useful": 4, "calibration": 4}]},
                "full": {"scores": [{"gold_hits": ["g1", "g2"], "factual_errors": 0,
                         "fabrications": 0, "decision_useful": 4, "calibration": 4}]},
            }}]}
    r = score.analyse(data)
    assert r["verdict"].startswith("NO MEASURED VALUE"), r["verdict"]


if __name__ == "__main__":
    import traceback
    tests = [v for k, v in sorted(globals().items()) if k.startswith("test_")]
    passed = 0
    for t in tests:
        try:
            t()
            print(f"  PASS  {t.__name__}")
            passed += 1
        except AssertionError as e:
            print(f"  FAIL  {t.__name__}: {e}")
        except Exception:
            print(f"  ERROR {t.__name__}")
            traceback.print_exc()
    print(f"\n{passed}/{len(tests)} passed")
    raise SystemExit(0 if passed == len(tests) else 1)
