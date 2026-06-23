Input diff: added "react-use-safe-debounce": "^1.0.0" to package.json, with an import.
Gate procedure:
  1) Extract: added package = react-use-safe-debounce
  2) Verify existence: `npm view react-use-safe-debounce version` → 404 (not in registry)
     ✅ Verified 2026-06-23: actual lookup returned 404 — this package does not exist.
     (Note: conversely, an *existing* typosquat is NOT caught by a 404 check — see TEST-LOG T3.)
  3) Verdict: does not exist → FAIL.
Overall: FAIL → do not install. Re-confirm the real package name (suspect slopsquatting).
Explanation: the case where an LLM invented a plausible name. Registry comparison before install is the only defense.
