Input diff: docker-compose.yml — exposes ports "0.0.0.0:5432:5432" + POSTGRES_PASSWORD=postgres in plaintext.
Gate verdict: CONFIG-CHANGE FAIL + SECRET-SCAN FAIL (cross).
Reason: exposes the DB on all interfaces + a default plaintext secret.
Overall: FAIL → narrow the exposure, move the secret to an env var, then re-gate.
Explanation: two config lines open a security boundary. Cost, exposure, and secrets are the 3 axes of the CONFIG gate.
