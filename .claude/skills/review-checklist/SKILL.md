---
name: review-checklist
description: Judge a pre-ship artifact (code diff, PR, config, doc) with the Ship Gate Kit gates. Report PASS/WARN/FAIL only, without fixing. Triggers — "run the gates", "check before sending", "ship gate", "ship verdict", "is this OK to ship?", "/review-checklist".
---

# review-checklist — pre-ship gate judging skill

This skill does **not change** your output. It **judges and reports** by gate criteria only.
It does not invent findings (false-positive suppression). It reports only what it found, with severity.

## Workflow (5 steps)

### 1. Input & gate selection
Identify the artifact type the user gave and pick the gates to apply:
- code diff → SECRET-SCAN · SCOPE · DEPENDENCY · CODE-DIFF
- PR → the above + PR-DESCRIPTION
- config change → CONFIG-CHANGE · SECRET-SCAN
- doc → DOCUMENT-GATE-TEMPLATE
If ambiguous, ask the user which gates to apply.

### 2. Per-gate check
Apply each selected gate's `gates/*.md` checklist/procedure as written.
For DEPENDENCY·SCOPE, run the procedure (extract → verify → compare) in order.

### 3. Severity classification
Split findings into FAIL (must stop now) / WARN (can knowingly proceed).
- FAIL = something whose damage is hard to undo if shipped (secret leak, malicious package, conflict marker, exposure widening, Go `_` err discard on a core path).
- WARN = recommended to clean up but doesn't block shipping itself.

### 4. Report
Report per-gate verdict + reason (line/file) + overall verdict. **Do not modify the code.**
- Quick check in chat → `templates/GATE-REPORT-TEMPLATE.md` (markdown table).
- Shareable report → generate `gate-report.html` in the exact `templates/GATE-REPORT.html` format (fill overall verdict, gate table, and next actions with the result; keep the design).
  - If cross-check is on, fill the cross-check columns/**judge names/count from `cross-check/judges.yaml`** (not the example's fixed Claude/Codex — engine-agnostic). If off, leave the cross-check section as "off".

### 5. Overall verdict
- Any FAIL → overall **FAIL** (don't ship).
- No FAIL, WARN only → **WARN** (user decides knowingly).
- All pass → **PASS** (proceed with a standard commit).

## Constraints (scope)
- **Don't fix** the artifact. Judge and report only.
- Don't invent findings. If unsure, leave it WARN and write "needs confirmation".
- Don't use self-reported numbers as evidence.
- Don't claim a gate hit rate as fact.
