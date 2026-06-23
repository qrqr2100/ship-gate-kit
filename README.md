# Ship Gate Kit — a pre-ship go/no-go gate kit

> **In one line**: not a line-by-line code review — a **single go/no-go decision right before you ship**.
> It catches secrets, scope drift, and non-existent packages in **one gate report**, and ends with a single word: **PASS / WARN / FAIL**.

A free kit for checking what AI (Claude Code and friends) produced — code diffs, PRs, release notes, config changes, docs — **before** you send it to a human.
Don't wait for a reviewer to catch it. **The sender screens it first.**

- **Who it's for**: solo developers and vibe coders building with Claude Code or other AI coding tools, and teams that just brought AI in — beginner to intermediate, worldwide.
- **It's not an editing kit**: the goal isn't to polish your writing, it's to **decide whether it can ship**. FAIL means fix it; PASS means it goes as-is. The gates **judge without changing** your output.

---

## Positioning — the first filter inside your AI build loop, before the dedicated tools

This kit does **not replace** dedicated tools like gitleaks, truffleHog, Socket, or Snyk.
Those go deeper and wider.

This kit sits **in front of them**: **a 1–2 minute first pass a human runs inside the Claude Code conversation, before committing.**
Before you reach for the dedicated tools, the sender first catches the "this is clearly off" level of exposure, hallucinated packages, and intent drift.

Dedicated-tool paths:
- Deeper secret scanning → **gitleaks / truffleHog / detect-secrets** (full history, automation)
- Deeper supply-chain → **Socket / Snyk** (dependency graph, licenses, CVEs)
- This kit provides the **report-style first pass** in that front spot, inside the Claude Code loop. It is not meant for auto-blocking or CI gating.

> Don't wire this kit into CI as an auto-block (see ANTI-PATTERNS.md). The moment you put it in CI, the "first filter inside the AI build loop" differentiator collapses.

---

## Why it's needed (the misses are real)

AI output leaks through "plausible but wrong" paths. The following are **reported real phenomena**
(external reports, not numbers this kit measured — numeric claims are deliberately omitted):

- **Secret leaks** — AI hardcodes an API key/token in code for an example or debug convenience, and it ships in a PR. Even if you scrub Git history, it's already in forks, mirrors, and CI logs.
- **Scope creep** — AI reads instructions literally and quietly changes adjacent files. If you only skim the file list of a diff, you miss the out-of-intent changes.
- **Slopsquatting** — an LLM invents a **non-existent package name** that looks plausible. An attacker registers that name first and plants malicious code — a supply-chain attack path. (Phenomenon: external reports such as Socket, arXiv — not measured by this kit.)

> The six gates provide a **1–2 minute pre-ship procedure** to block these paths.
> (How much the gates actually catch — the **hit rate is [unverified]**. This kit provides a "decision procedure"; empirical data does not exist yet.)

---

## Files (28 core + cross-check option)

```
ship-gate-kit/
  README.md                          # this document
  QUICK-START.md                     # 3-step intro + text walkthrough
  DECISION-LOG.md                    # design rationale (D1–D5)
  ANTI-PATTERNS.md                   # how the gates fail in practice
  TEST-LOG.md                        # self-verification results (honesty baseline)
  TEAM-ADOPTION.md                   # solo → team rollout
  FAQ.md                             # 10 common questions
  CHANGELOG.md

  gates/
    SECRET-SCAN.md                   # secret/key/credential exposure (with language-specific patterns)
    SCOPE.md                         # out-of-intent file changes
    DEPENDENCY.md                    # non-existent packages
    CODE-DIFF.md                     # risky code patterns (with language-specific patterns)
    PR-DESCRIPTION.md                # PR body accuracy
    CONFIG-CHANGE.md                 # config change safety

  .claude/skills/review-checklist/
    SKILL.md                         # the unified 6-gate judging skill

  templates/
    GATE-REPORT-TEMPLATE.md          # gate report (markdown table — quick check in chat)
    GATE-REPORT.html                 # gate report (HTML — single + cross-check, shareable)
    PR-TEMPLATE.md
    RELEASE-NOTE-TEMPLATE.md
    DOCUMENT-GATE-TEMPLATE.md

  examples/
    EXAMPLE-01-PASS.md
    EXAMPLE-02-FAIL-SECRET.md
    EXAMPLE-03-FAIL-SCOPE.md
    EXAMPLE-04-FAIL-DEPENDENCY.md
    EXAMPLE-05-FAIL-CONFIG.md
    EXAMPLE-06-WARN.md
    EXAMPLE-07-FAIL-PR-DESCRIPTION.md   # PR description ↔ diff mismatch
    EXAMPLE-08-FAIL-CONFIG-CHANGE.md    # GitHub Actions permission escalation
    EXAMPLE-09-PYTHON-SECRET.md         # Python-specific secret pattern
    EXAMPLE-10-JS-PROMISE.md            # JS-specific async error suppression
    EXAMPLE-11-GO-ERR.md                # Go-specific err discard
    EXAMPLE-12-RUST-ENV.md              # Rust-specific env!() misuse

  cross-check/                         # (option) multi-judge cross-check mode — only when you need more confidence
    CROSS-CHECK.md                     # design · how to enable · deterministic N-judge merge rules
    judges.example.yaml                # judge registry starter (engine-agnostic, pluggable)
    scripts/lint-gate.sh               # non-LLM deterministic linter (regex + registry lookup)
    # (the report is unified into templates/GATE-REPORT.html — when cross-check is on, the matrix appears there)
```

> **Cross-check mode (`cross-check/`) is optional.** The default is a single judge (review-checklist). Only when you need more confidence (payments, auth, releases) do you run 2+ judges (Claude, Codex, Gemini, local LLM, deterministic linter, etc.) independently and look at agreement/disagreement. Whether cross-check actually catches more than a single judge is [unverified] — see `cross-check/CROSS-CHECK.md`.

---

## Install · Use 1-2-3

1. **Install** — drop the `ship-gate-kit/` folder at your project root. Make sure `.claude/skills/review-checklist/` lands under your project's `.claude/skills/`.
2. **Judge** — before sending, hand this to Claude Code:
   > "Run the ship-gate-kit gates on this diff. Apply SECRET-SCAN, SCOPE, and DEPENDENCY from `gates/`, and report PASS/WARN/FAIL in the GATE-REPORT-TEMPLATE format. Don't fix the code — judge only."
3. **Ship** — if the gate is **PASS**, do a standard commit (`git commit`) and send it. If **FAIL**, fix the reported items and re-gate. If **WARN**, decide whether to knowingly proceed.

> Flow: **gate (judge) → commit (after pass) → ship.** The gate stands in front of the commit.
> Don't use it for CI automation (see ANTI-PATTERNS.md).

---

## License

MIT © 2026 Solo Bare Ground — see `LICENSE`. Free to use, modify, and distribute.
