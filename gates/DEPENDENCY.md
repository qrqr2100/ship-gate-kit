# GATE: DEPENDENCY — non-existent package

## Purpose
Before shipping, judge whether the imports/dependencies the AI added include a
**non-existent package (a slopsquatting target)** or a suspicious new dependency.

## How it gets missed
- The AI invents a plausible name (like `react-use-debounce-hook`) and imports it. You don't see it until build time.
- A typo-similar package (`lodahs`) gets installed.
- A heavy/unvetted new dependency suddenly appears.

## Procedure (3 steps — not a checklist)
1. **Extract** — pull the **list of added package names** from the diff's `package.json` / `requirements.txt` / import statements.
2. **Verify existence** — check each name against the registry:
   - npm: `npm info <name>` (404 if missing) or check npmjs.com/package/<name>.
   - PyPI: `pip index versions <name>` or check pypi.org/project/<name>.
   - Go (pkg.go.dev): `go list -m <module>@latest` or check pkg.go.dev/<path>.
   - Rust (crates.io): `cargo search <crate>` or check crates.io/crates/<name>.
   → if **not in the registry**, or present but **near-zero downloads / recently registered**, suspect slopsquatting.
3. **Verdict** — non-existent → FAIL immediately. Existent but suspicious → WARN.

> Why it matters: an attacker pre-registers a non-existent name and plants a malicious package. The install itself is the breach.

## How to hand it to Claude Code
> "Apply the DEPENDENCY gate to this code (a diff, file, or snippet). Extract every added package name,
> and check each for existence on npm/PyPI/pkg.go.dev/crates.io (look it up directly if you can, otherwise give me a command to check).
> Verdict FAIL if it doesn't exist, WARN if it exists but is new/low-download."

## When to move to a dedicated tool
For deeper supply-chain analysis (CVEs, licenses, dependency graph), move to **Socket** or **Snyk**.

## [Unverified]
- Whether Claude Code can reach the registry directly over the internet depends on the environment (unverified).
  When it can't, the gate only goes as far as proposing a "command for the user to run".
- The number of times this gate has actually caught a hallucinated package is unmeasured.
- A "404 = FAIL" check catches *non-existent* packages but does **not** catch *existing* typosquats (a package that exists on the registry but is malicious) — that needs an LLM judge / human check (downloads, registration date, name similarity).
