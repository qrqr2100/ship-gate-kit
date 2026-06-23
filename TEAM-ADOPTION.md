# TEAM-ADOPTION — rolling out from solo to team

This file covers where friction actually appears when adopting Ship Gate Kit in a team.
Adopt it by **agreement, not by force** — that's how the gate survives.

---

## Why forced adoption fails

A gate is not a tool, it's an **agreement on judgment criteria**.
If the team doesn't agree that "we don't send it when it FAILs", the gate becomes decoration.
Forced adoption → the team ignores or bypasses the gate → a leak happens despite the gate → "the gate is the problem".

---

## Step 1 — Agree on FAIL criteria (30 min)

Before the team first uses Ship Gate Kit, decide these together:

1. **Which gates are mandatory on our PRs?**
   Suggested default: SECRET-SCAN·SCOPE·DEPENDENCY (3 mandatory, the rest optional)
   Team decision: ___

2. **When it FAILs, must we always stop, or can we note a reason and proceed?**
   Suggested: FAIL stops in principle. Exceptions: state the reason in the PR + lead confirmation.
   Team decision: ___

3. **Is there anything extra the team wants to define as knowingly-proceed-OK vs not (WARN basis)?**
   e.g. an internal-only repo doesn't promote a debug print WARN to FAIL.
   Team decision: ___

4. **How is the gate report attached to the PR?**
   Suggested: attach the GATE-REPORT-TEMPLATE summary to the PR-TEMPLATE "Gate result" item.
   Team decision: ___

---

## Step 2 — First 2 weeks of observation

- For the first 2 weeks, don't block PRs even on FAIL. Just record the FAIL items in PR comments.
- Retro after 2 weeks: "which FAILs were real problems? which were excessive?"
- Use that data to tune FAIL/WARN criteria to the team's reality.

Reason: if the gate blocks PRs from day one, the team resists. An observation period to confirm the criteria's validity together
builds trust in the gate.

---

## Step 3 — The habit of attaching the gate report to the PR

What attaching the gate report to the PR produces:
- The reviewer doesn't have to ask "did this PR run the gate?".
- As PASS reports accumulate, a team norm of "gate pass = minimum ship hygiene" forms.
- Later, in a "why did you send this?" situation, the gate report is the evidence.

How: copy the GATE-REPORT-TEMPLATE summary into the PR-TEMPLATE "Gate result" item.

---

## Common friction

**"Running the gate on every PR is annoying"**
→ For code diffs, just SECRET-SCAN·SCOPE·CODE-DIFF (3). Add CONFIG-CHANGE for config changes.
  Running all of them isn't the default — run only the ones that fit the artifact type (see SKILL.md step 1).

**"Claude Code said FAIL but I think it's fine"**
→ If you disagree with the verdict, the rule is "state the reason in the PR". You don't ignore and proceed.
  If disagreements repeat, re-agree on the FAIL/WARN criteria.

**"A teammate uploads a PR without running the gate"**
→ Before enforcing with tooling, ask "why didn't you run it?" first.
  Too annoying = simplify the process / gate feels meaningless = re-agree criteria / didn't know = point to QUICK-START.
