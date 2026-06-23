# ANTI-PATTERNS — how gate operation fails

This file covers **the wrong ways to use** Ship Gate Kit.
Patterns where the gate becomes meaningless, the team starts ignoring it, or it gives false security.

---

## AP-1. Promoting every WARN to FAIL

**What it does**: marks one TODO, one console.log, a few commented lines all as FAIL and blocks shipping.

**Why it's bad**:
- If the gate FAILs on every PR, the team starts ignoring the gate.
- Once it's "crying wolf", real FAILs (secret leaks, hallucinated packages) get ignored too.
- WARN is "proceed knowingly". Leaving that judgment to the human is the gate's design.

**Correct criteria**:
- FAIL = something whose damage is hard to undo if shipped (secret leak, malicious package, permission widening, conflict marker).
- WARN = recommended cleanup that doesn't block shipping itself.

---

## AP-2. Wiring the gate into CI as an auto-block

**What it does**: puts review-checklist into `.github/workflows/` to build automation that blocks merges.

**Why it's bad**:
- This kit is designed as "a report-style procedure a human runs inside the Claude Code conversation".
  As a CI auto-block, it blocks merges with far lower coverage/accuracy than dedicated tools (gitleaks, Socket).
- With incomplete language patterns, no-registry-access environments, and unmeasured hit rate, auto-blocking risks false positives/malfunctions.
- See DECISION-LOG D5.

**Correct alternative**: if you need CI automation, use dedicated tools. This kit is the manual step in front.

---

## AP-3. Using the gate to fix code

**What it does**: asks "run the gate and also fix the problems".

**Why it's bad**:
- If the gate also fixes, the fix itself becomes another gate target — infinite loop.
- Separating judgment from fixing keeps the trust loop "what I shipped passed the gate".
- If you don't re-gate after fixing, the fixed code skips the gate.

**Correct flow**: gate verdict → human (or a separate Claude Code request) fixes → re-gate → PASS → ship.

---

## AP-4. Not attaching the gate report to the PR when there's no FAIL

**What it does**: doesn't attach the gate report to the PR if you only got a PASS.

**Why it's bad**:
- The reviewer has no way to know "did this PR run the gate?".
- To build gate trust during team rollout, PASS reports should be visible too.

**Correct habit**: attach the GATE-REPORT summary to the "Gate result" item of the PR-TEMPLATE.

---

## AP-5. Using only this kit instead of dedicated tools

**What it does**: decides this kit is enough, without gitleaks/Socket/Snyk.

**Why it's bad**:
- This kit doesn't scan full Git history. It only sees the pre-commit diff.
- Secrets already committed/pushed are not caught by this kit.
- Dependency graphs, CVEs, and licenses are out of this kit's scope.

**Correct position**: this kit is a first pass. As the team/project grows, run dedicated tools alongside.
Secrets → gitleaks / packages → Socket or Snyk.

---

## AP-6. Setting up the gate once and never updating it

**What it does**: doesn't adjust gates/*.md to the team's situation after install.

**Why it's bad**:
- FAIL criteria differ per project. A public open-source repo treats a committed `.env` as immediate danger,
  but a local-only experiment repo may have a different context.
- If the gate doesn't fit the context, the team ignores it (same result as AP-1).

**Correct management**: when first rolling the gate out to a team, agree on FAIL criteria together (see TEAM-ADOPTION.md).
