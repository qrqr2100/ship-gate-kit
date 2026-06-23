# FAQ — frequently asked questions

---

**Q1. Do I have to run all gates on every commit?**

No. Pick only the gates the artifact type needs.
- code diff → SECRET-SCAN · SCOPE · DEPENDENCY · CODE-DIFF
- before opening a PR → the above + PR-DESCRIPTION
- only config files changed → CONFIG-CHANGE · SECRET-SCAN
- only docs changed → DOCUMENT-GATE-TEMPLATE

"All 6" is not the default. review-checklist SKILL.md step 1 picks them by type automatically.

---

**Q2. Does the DEPENDENCY gate work in an offline environment?**

Direct registry lookup won't. In that case the gate only goes as far as proposing "a command for you to run":
- npm: `npm info <name>` (in your terminal)
- PyPI: `pip index versions <name>`
You run that command in the terminal and confirm the result yourself.
Whether Claude Code has internet access depends on the environment, so it's [unverified].

---

**Q3. Can I put the gate in CI to auto-block merges?**

Not recommended, for two reasons:
1. This kit's limits (incomplete language patterns, unmeasured hit rate, uncertain registry access) becoming the auto-block criteria risks false positives/malfunctions.
2. This kit's differentiator is "the report-style first filter inside the AI build loop". As a CI auto-block it's no better than dedicated tools.
If you need CI automation, move to gitleaks (secrets) / Socket·Snyk (packages). See DECISION-LOG D5.

---

**Q4. What if a teammate ignores the gate result and opens a PR?**

Find the reason before enforcing with tooling:
- process is annoying → reduce mandatory gates or re-point to QUICK-START.
- they think the verdict is wrong → re-agree FAIL/WARN criteria as a team (see TEAM-ADOPTION.md).
- they just ignore it → first agree as a team norm to attach the gate report to PRs.
Enforcing via auto-block is ANTI-PATTERNS AP-2.

---

**Q5. How is this different from dedicated secret scanners (gitleaks·truffleHog)?**

Dedicated scanners catch wider and deeper than this kit:
- full Git history scan (this kit sees only the current diff)
- entropy-based detection (this kit is pattern/prefix-based)
- CI integration, automation, audit logs

This kit is the step before: inside the Claude Code conversation, before commit, a 1–2 minute first pass a human runs.
Not "instead of gitleaks" but "before going to gitleaks".

---

**Q6. There's a WARN — can I still send the PR?**

If you're sending it knowingly, yes.
WARN isn't "blocks shipping", it's "decide knowingly". Note "WARN item X, proceeding knowingly" in the PR description and send.
Blocking on WARN like a FAIL makes the gate get ignored (see ANTI-PATTERNS AP-1).

---

**Q7. What if the gate PASSed but a problem is found later?**

A PASS doesn't guarantee "no problems".
This kit provides a "decision procedure" — passing the gate means "no problem found in this gate's checklist".
Real hit rate/coverage is [unverified]. The gate is a minimum safety net, not a full guarantee.

---

**Q8. Do I need all 6 gates? Can I use just 3?**

Yes. Use only the gates the team agreed are mandatory, and the rest optionally when that artifact type appears.
Minimum recommended: SECRET-SCAN (secrets) · SCOPE (intent drift) · DEPENDENCY (hallucinated packages).
Add CONFIG-CHANGE for config changes. Add PR-DESCRIPTION for PRs.

---

**Q9. Can I use it on non-Python language projects?**

Yes. The gate checklists sit on a language-agnostic common base, and the language-specific patterns are opt-in.
Go·Rust·JS/TS projects reference their language-specific sections (SECRET-SCAN·CODE-DIFF).
Language-specific measurement is [unverified].

---

**Q10. Can I change the gate criteria to fit my project?**

Yes — it's recommended. The `gates/*.md` files are copy-paste starting points.
Adjust FAIL/WARN criteria, add language-specific patterns, and remove unneeded checks for your team's situation.
Record what you adjusted, with the reason, in DECISION-LOG.md so you can later trace "why was this the criterion?".
