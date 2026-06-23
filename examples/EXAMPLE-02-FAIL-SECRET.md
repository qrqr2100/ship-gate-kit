Input diff: added const OPENAI_KEY = "sk-proj-abc123...(48 chars)" to src/api.ts.
Gate verdict: SECRET-SCAN FAIL.
Reason: src/api.ts:12 — 'sk-' prefix + 48-char key = presumed real secret.
Overall: FAIL → do not ship. Move the key to an environment variable; if already committed, revoke/rotate it.
Explanation: even "for an example", a real key format is a leak. The gate doesn't fix it — it reports the location and reason only.
