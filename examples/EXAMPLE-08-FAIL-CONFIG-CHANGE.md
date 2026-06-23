Input diff: .github/workflows/deploy.yml

Before: permissions: contents: read
After:  permissions: contents: write / id-token: write / packages: write

Gate verdict: CONFIG-CHANGE FAIL.
Reason: 3 permissions widened. id-token: write allows OIDC token issuance — a hijacked workflow risks cloud credentials.
Overall: FAIL → open only the minimum permissions, or state the intent in the PR and get security review, then re-gate.
Explanation: CI config changes get the least attention and have the widest impact. Permission widening always starts at FAIL.
