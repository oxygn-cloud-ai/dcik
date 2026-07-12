import os,json,sys,urllib.request
KEY=os.environ["DEEPSEEK_API_KEY"]
STATE="retest/state.json"
q=sys.stdin.read().strip()
msgs=json.load(open(STATE)) if os.path.exists(STATE) else None
if msgs is None:
    system=open("retest/system.txt").read()
    msgs=[{"role":"system","content":system}]
msgs.append({"role":"user","content":q})
body=json.dumps({"model":"deepseek-chat","messages":msgs,"max_tokens":650,"temperature":0.8}).encode()
req=urllib.request.Request("https://api.deepseek.com/v1/chat/completions",data=body,headers={"Authorization":f"Bearer {KEY}","Content-Type":"application/json"})
a=json.load(urllib.request.urlopen(req,timeout=90))["choices"][0]["message"]["content"]
msgs.append({"role":"assistant","content":a})
json.dump(msgs,open(STATE,"w"),indent=1)
print(a)
