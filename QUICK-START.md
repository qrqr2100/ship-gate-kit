# QUICK-START — from install to your first report

This is a **walkthrough**, not an explanation. The shortest path for someone using Ship Gate Kit for the first time to get their first judgment report.

## Step 1 — Install (2 min)

1. Copy this `ship-gate-kit/` folder to your project root.
2. Make sure `.claude/skills/review-checklist/SKILL.md` is at your project's `.claude/skills/review-checklist/SKILL.md`.
3. Done. Installation is just copying files. No npm install, no pip install.

## Step 2 — First judgment (1–2 min)

Paste the following into Claude Code as-is. Change only the `<…>` parts:

```
Run the ship-gate-kit gates on this diff.

My intent: <one line — e.g. "fix only the bug in auth/login.ts">
Gates to apply: SECRET-SCAN, SCOPE, DEPENDENCY, CODE-DIFF
Report format: gates/GATE-REPORT-TEMPLATE.md
Rules: don't fix the code, judge only. Don't invent findings.

diff:
<paste the diff here>
```

## Step 3 — Read the report

Claude Code answers in this shape:

```
# Gate Report — auth-fix.diff (2026-06-21)

| Gate          | Verdict | Reason                          |
|---------------|---------|---------------------------------|
| SECRET-SCAN   | PASS    |                                 |
| SCOPE         | FAIL    | utils/format.ts changed — out of intent |
| DEPENDENCY    | PASS    | no new packages                 |
| CODE-DIFF     | WARN    | src/login.ts:47 leftover console.log |

Overall: FAIL
FAIL item: SCOPE — decide whether utils/format.ts belongs in scope, then re-gate.
```

**If FAIL**: fix only the reported items and go back to Step 2.
**If WARN**: decide whether to knowingly proceed. WARN-only can ship.
**If PASS**: ship with a standard commit (`git commit`). (Use a `git-commit` skill if you have one.)

## (Optional) Get an HTML report

To keep or share the result as a file, after you get the judgment say:

```
Save the gate judgment as gate-report.html in the exact templates/GATE-REPORT.html format.
Replace only the artifact, gate verdicts, reasons, overall verdict, and next actions with my result. Keep the design.
```

→ You get a single-page report (navy design) with overall verdict, the gate table, and next actions. Attach it to a PR/issue or keep it for the record.
If cross-check is on, the judge columns/names in the report are filled from `cross-check/judges.yaml` (engine-agnostic — not fixed to the example's Claude/Codex). If it's off, it shows "Cross-check: off".

## Where people get stuck

- No git, or live/running code? Paste the file or code snippet directly — SECRET-SCAN, DEPENDENCY, CODE-DIFF, and CONFIG-CHANGE work on it as-is. (Only SCOPE and PR-DESCRIPTION need a change-set or a PR.)
- If Claude Code can't get the diff: copy the output of `git diff HEAD~1` and paste it.
- If the DEPENDENCY gate hits "no internet access": run the command Claude Code suggests (`npm info <name>`, etc.) in your terminal yourself.
- If a verdict isn't what you expected: check that you specified the GATE-REPORT-TEMPLATE format.
