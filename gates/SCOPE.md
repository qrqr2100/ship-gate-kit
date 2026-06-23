# GATE: SCOPE — out-of-intent file change

## Purpose
Judge whether the intent "this change only touches X" matches the range the diff actually touched.
Catch the files the AI quietly changed before you ship.

## How it gets missed
- "Fix the login bug" → besides the auth file, shared utils and formatting also change.
- Unrelated files change in bulk under the banner of "refactoring".
- Build artifacts (dist/, lock files) slip into the diff unintentionally.

## Procedure (3 steps — not a checklist)
1. **Declare intent** — the sender writes one line: "This change touches only the ___ file(s) for ___."
2. **Extract the actual file list** — pull every file path the diff touched (`git diff --name-only` equivalent). *(No git? The user lists "the files I changed" directly — same for live code / hotfixes.)*
3. **Compare** — flag every change **outside** the declared range.
   For each flag, ask: "Is this change part of the intent?"

> Why it matters: out-of-declaration changes are a path for code no reviewer or builder examined to reach production.

## Verdict criteria
- **FAIL** — a file outside the declaration has a **logic change** with no explanation. Don't ship (re-declare intent or remove the change).
- **WARN** — out-of-declaration changes exist but are formatting / auto-generated (lock, etc.) and look harmless. Decide whether to proceed.
- **PASS** — all changes are within the declared range.

## How to hand it to Claude Code
> "Apply the SCOPE gate to this change (a git diff, or the list of files I changed). My intent is '____'.
> Extract the diff's file list, flag every file change outside my intent,
> classify each as a logic change vs formatting/auto-generated, and verdict FAIL/WARN/PASS."

## [Unverified]
- The real accuracy of auto-comparing the intent declaration against the diff is unmeasured.
