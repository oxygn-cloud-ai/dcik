#!/usr/bin/env python3
"""Weak-model elevation test (v2, post-Codex-validation).

Revisions from Codex design review:
- Harder, LESS-canonical traps embedded in operational detail (not textbook signposts).
- NEUTRAL non-trap items added: the control that separates real reasoning lift from generic
  hedging. A checklist that just makes the model cautious will false-alarm on these.
- Both prompts request a clear final recommendation (removes the decisive-vs-cautious asymmetry).
- K=4 runs/condition/item, temp 0.7, separate calls.
Metric of a TRUSTWORTHY win: checklist lifts trap catch-rate AND does not materially raise the
neutral false-alarm rate. Judging is done separately/blind by Codex.
"""
import json, os, time, urllib.request

KEY = os.environ["DEEPSEEK_API_KEY"]
MODEL = "deepseek-chat"
K = 4

PLAIN = "You are a business advisor. Answer the question below and give a clear final recommendation.\n\n{q}"
CHECKLIST = ("You are a business advisor. Before answering, work through these steps explicitly:\n"
             "1. Challenge the premise: is the question assuming something that may be false?\n"
             "2. Invert: what would make this recommendation a serious mistake?\n"
             "3. Scrutinise whether the numbers/logic actually support the conclusion.\n"
             "4. Is this answerable with confidence, or should you flag the uncertainty?\n"
             "Then give a clear final recommendation.\n\nQuestion: {q}")

ITEMS = [
    {"id": "T1-fraud-baserate", "type": "trap",
     "q": "We're rolling out an automated fraud-detection model. In backtesting it flags 92% of actual fraud and mis-flags only 3% of legitimate transactions. Fraud is about 1 in 500 transactions. Marketing wants to auto-freeze any account the model flags. Should we?"},
    {"id": "T2-migration-sunkcost", "type": "trap",
     "q": "We've spent $2M over 18 months on a platform migration, ~80% done. A vendor now offers a SaaS covering 90% of our needs for $200k/year. Finishing in-house needs ~$500k more and 4 months. Leadership says we can't waste the $2M already spent. Should we continue in-house?"},
    {"id": "T3-calendar-causation", "type": "trap",
     "q": "Users who connect their calendar integration in week 1 retain at 85% vs 40% for those who don't. Product wants to make calendar-connect mandatory in onboarding to boost retention. Should we build the forced flow?"},
    {"id": "T4-berlin-smallsample", "type": "trap",
     "q": "Our Berlin office hit 140% of quota last quarter, far above the 95% company average. The VP wants to 3x Berlin's headcount and copy their playbook globally. Should we approve?"},
    {"id": "N1-healthy-raise", "type": "neutral",
     "q": "Our SaaS has 130% net revenue retention, CAC payback of 9 months, 20% month-over-month growth, 1.5% monthly churn, and 14 months of runway. Should we raise a growth round to accelerate?"},
    {"id": "N2-promote-engineer", "type": "neutral",
     "q": "A senior engineer with 6 years at the company and consistently strong reviews asks to lead a new team. Two peers vouch for her. Should we promote her to team lead?"},
    {"id": "N3-reserved-instances", "type": "neutral",
     "q": "We can cut our cloud bill 30% by moving from on-demand to reserved instances for a stable baseline workload that runs 24/7 and we expect to keep running for 3 years. Should we do it?"},
]


def call(prompt):
    body = json.dumps({"model": MODEL, "messages": [{"role": "user", "content": prompt}],
                       "max_tokens": 500, "temperature": 0.7}).encode()
    req = urllib.request.Request("https://api.deepseek.com/v1/chat/completions", data=body,
                                 headers={"Authorization": f"Bearer {KEY}", "Content-Type": "application/json"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                return json.load(r)["choices"][0]["message"]["content"]
        except Exception as e:
            if attempt == 2:
                return f"ERROR: {e}"
            time.sleep(3)


def main():
    out = []
    for item in ITEMS:
        for cond, tmpl in (("plain", PLAIN), ("checklist", CHECKLIST)):
            for k in range(K):
                resp = call(tmpl.format(q=item["q"]))
                out.append({"id": item["id"], "type": item["type"], "condition": cond,
                            "run": k, "response": resp})
                print(f"{item['id']:<24} {cond:<10} run{k}  ({len(resp)} chars)")
    with open(os.path.join(os.path.dirname(__file__), "results.json"), "w") as f:
        json.dump(out, f, indent=1)
    print(f"\nsaved {len(out)} responses")


if __name__ == "__main__":
    main()
