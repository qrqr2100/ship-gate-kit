Language-specific pattern — Python os.environ.get() fallback misuse

Input diff: config.py

Before: API_KEY = os.environ.get("OPENAI_KEY")
After:  API_KEY = os.environ.get("OPENAI_KEY", "sk-proj-realkey-48chars-xxxx")

Gate verdict: SECRET-SCAN FAIL.
Reason: a 'sk-' prefix key sits as the fallback (second arg) of os.environ.get().
      If the env var is unset, the real key is used directly from code.
Overall: FAIL → remove the fallback + replace with an explicit error when the key is missing.
Explanation: Python-specific. A "convenience fallback" becomes a path that bakes the secret into code.
      JS's `||` short-circuit and Go's const block are the same intent in different syntax.
