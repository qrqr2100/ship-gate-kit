# GATE: CONFIG-CHANGE — config change safety

## Purpose
Judge whether a config change (CI, build, infra, runtime settings) ships safely.
One config line changes deployment, security, or cost.

If you also use a `config-doctor` skill for config changes, attaching its diagnosis to this gate report reduces duplicate checking.

## Checklist (why it matters)
- [ ] Permission/exposure widening: public switch, 0.0.0.0 bind, permission wildcards
      → unauthorized access path.
- [ ] Secret/token in plaintext config? (→ cross-checks with the SECRET-SCAN gate)
- [ ] Cost triggers: bigger instance, longer log retention, unlimited concurrency
      → surprise billing.
- [ ] Safety guard removal: timeout removed, infinite retries, validation disabled
      → failure propagation.
- [ ] Version pin removed (`^`/`latest`) → reproducibility lost
      → "it worked on my machine".

## Real verdict examples — what this gate catches

**Example A — GitHub Actions permission escalation (FAIL)**

diff (`.github/workflows/deploy.yml`):
```yaml
-  permissions:
-    contents: read
+  permissions:
+    contents: write
+    id-token: write
+    packages: write
```

Verdict: CONFIG-CHANGE FAIL
Reason: permissions widened from `read` to `write` + `id-token: write` + `packages: write` (3 steps).
`id-token: write` allows OIDC token issuance — a hijacked workflow risks cloud credentials.
Next action: open only the minimum permissions, or note the intended change in the PR description and re-review.

**Example B — timeout removal + cost trigger (FAIL + WARN)**

diff (`docker-compose.yml`):
```yaml
-    healthcheck:
-      timeout: 10s
-      retries: 3
```
```yaml
+    deploy:
+      replicas: 20
```

Verdict:
- `healthcheck` removed → CONFIG-CHANGE FAIL (safety guard removed: an unhealthy container takes traffic without restart)
- `replicas: 20` → CONFIG-CHANGE WARN (cost trigger: confirm whether this scale-up is intended)

## How to hand it to Claude Code
> "Apply the CONFIG-CHANGE gate to this config (a diff or the config file). List risky changes from the angle of
> permissions, secrets, cost, safety guards, and version pinning, and verdict FAIL/WARN/PASS."

## [Unverified]
- Per-infra-type detail patterns (GitHub Actions, Docker, k8s, Terraform, etc.) need expansion.
