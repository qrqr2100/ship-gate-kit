# CHANGELOG — Ship Gate Kit

## v1.0.2 — 2026-06-23
- Added one live-system field test (TEST-LOG T8): 5/6 gates worked on a no-git running system, with 0 SECRET false positives, 0 hallucinated dependencies, and SCOPE's git-free mode confirmed. (Single run — hit rate still not generalizable.)

## v1.0.1 — 2026-06-23
- Input generalized: gates apply to a diff, a file, a code snippet, or live code — not only git diffs.
  SECRET-SCAN · DEPENDENCY · CODE-DIFF · CONFIG-CHANGE work directly on code/files; only SCOPE (declare "files I changed") and PR-DESCRIPTION stay change-set/PR based.
  Opens the kit to non-git builders and live-system operators.

## v1.0.0 — 2026-06-23
- First release. 6 gates (SECRET-SCAN·SCOPE·DEPENDENCY·CODE-DIFF·PR-DESCRIPTION·CONFIG-CHANGE)
  · review-checklist skill · 4 templates · 12 examples · cross-check mode (option).
