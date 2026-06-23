# TEST-LOG — Ship Gate Kit self-verification results

> This file is this kit's self-verification record.
> Honesty principle: what's measured is called measured, document review is called document review, and incomplete is called incomplete.
> Anything not written as "verified" is not verified.

---

## T1. review-checklist skill — tier-1 isolated test (measured)

- Date: 2026-06-19
- By: the maker
- Method: planted 3 defects (hardcoded API key, possible ZeroDivisionError path, debug print) into a diff
  and asked the review-checklist skill to "review it".
- Result:
  - All 3 planted defects caught (SECRET-SCAN/CODE-DIFF family).
  - 0 invented defects (0 false positives).
  - Did not modify the code directly (report-style behavior confirmed).
- Scope note: this test covers part of the SECRET-SCAN/CODE-DIFF family.
  It did not reproduce the actual judgment of SCOPE (intent comparison) or DEPENDENCY (registry existence lookup).
- Interpretation: confirms "the review-checklist skill behaves report-style under these conditions and found the defects with no false positives".
  It does not support "this kit catches X% of secrets".

---

## T2. 6-gate paper adversarial test — document test (not a real project)

- Method: applied the 6 gates' checklists/procedures at the document level to adversarial cases to confirm logical completeness.
- Result: all 6 gates' checklists can respond to the miss scenarios each gate intends.
- Limit: this is a **document logic review**. How many it catches when Claude Code applies the gates on a real project diff,
  and how many false positives appear, was **not measured**.
- This result cannot say "the 6 gates have an X% hit rate".

---

## T3. DEPENDENCY registry lookup — partial measurement (2026-06-23) / SCOPE — [unverified]

**DEPENDENCY (measured, 2026-06-23):**
- Live `npm view` lookup: `react-use-safe-debounce` (the fake package in EXAMPLE-04) → **confirmed 404 FAIL**. `react`·`lodash` → exist, PASS.
- ⚠️ **Limit found**: `lodahs` (a lodash typosquat) exists on npm as a `security-hold` package, so the "404=FAIL" deterministic linter **passes it = miss**. That is, the deterministic linter's DEPENDENCY (`cross-check/scripts/lint-gate.sh`) only catches *non-existent* packages (slopsquatting first pass), not *existing malicious/typo* packages → that's the LLM judge's / a human's job (downloads, registration date, name similarity) — the WARN procedure in DEPENDENCY.md covers it.
- Interpretation: the "hallucinated (non-existent) package first pass" works as measured. "Typosquatting (exists but malicious)" is outside the deterministic linter's range — hit rate itself is still unmeasured.

**SCOPE (still [unverified]):** real-project reproduction of intent-declaration ↔ diff auto-comparison not done.

---

## T4. Slash UI (`/review-checklist` trigger) — [unverified]

- Status: not done.
- Needed: confirm the actual `/review-checklist` trigger firing in the Claude Code interactive environment.
- Why not done: no real Claude Code UI environment measurement.

---

## T5. Byte weight — measured (2026-06-23)

- Publish directory measured: **35 files / ~80KB** (28 core + CHANGELOG + cross-check option + scripts).
- File count clears the free-tier floor (14). Weight is judged by content substance rather than bytes — not padded to inflate size.
- No padding: composed of real content (gate definitions, 12 examples, cross-check contract, deterministic rules).

---

## T6. Language-specific patterns (Python·JS·Go·Rust) — [unverified]

- Status: pattern logic authored / not applied to a real codebase.
- The Python `os.environ.get()` fallback, JS `||` short-circuit, Go `_` discard, and Rust `env!()` macro patterns
  are based on real language traits, but how much this kit's gate actually catches is unmeasured.

---

## T7. Deterministic linter (cross-check) — measured (2026-06-23)

- Method: ran `cross-check/scripts/lint-gate.sh` against 3 fixtures.
- Result:
  - File with 3 fake keys (`sk-proj-…`·`AKIA…`·`password: …`) → **SECRET-SCAN FAIL** (with match locations).
  - Clean code → **PASS**.
  - `.env.example` placeholders (`your-key-here`·`xxxxxxxx`) → **PASS = no false positive**.
- Interpretation: the deterministic linter's SECRET-SCAN works under these conditions and did not flag obvious placeholders.
  The possibility of missing obfuscated/encoded keys remains [unverified] (an inherent limit of regex-based scanning).
