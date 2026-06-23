# GATE: PR-DESCRIPTION — PR body accuracy

## Purpose
Judge whether the PR description **matches** the actual diff and whether information a reviewer needs is missing.
(AI-written PR descriptions tend to claim features not in the diff, or omit what was done — a reported phenomenon.)

## Checklist (why it matters)
- [ ] Is every change described in the body actually in the diff? (describing a non-existent feature = message-code mismatch)
- [ ] Is every major change in the diff described in the body? (a missing change = the reviewer doesn't see it)
- [ ] Is whether/how it was tested stated?
- [ ] If there's a breaking change, is it noted?
- [ ] Is a rollback method/risk stated? (for risky changes)

## Verdict criteria
- **FAIL** — the description contradicts the diff (claims a missing feature, or omits a core change). Don't ship.
- **WARN** — test/rollback info is thin but the change itself is accurate. Recommend filling it in.
- **PASS** — description matches the diff and includes the key info.

## Real verdict examples — what this gate catches

**Example A — a non-existent feature is in the description (FAIL)**

PR description (AI-written):
> "Added a password reset feature. Implemented email sending, token verification, and expiry handling."

Actual diff:
- `auth/reset.ts` — only token generation logic added
- no email sending (`mailer.ts`) or expiry handling code

Verdict: PR-DESCRIPTION FAIL
Reason: the description has "email sending / expiry handling" but the diff doesn't. The reviewer ends up reviewing code that doesn't exist.
Next action: align the description with the diff (fix the scope) / or add the missing code, then re-gate.

**Example B — a core change is missing from the description (FAIL)**

PR description (AI-written):
> "Improved the API response format."

Actual diff:
- `api/response.ts` — response field `user_id` renamed to `userId` (breaking change)
- 3 client call sites reference `user_id` — not fixed

Verdict: PR-DESCRIPTION FAIL
Reason: the breaking change is missing from the description + client fixes are missing. If merged unknowingly, the clients break.

## How to hand it to Claude Code
> "Cross-check this PR description against the diff with the PR-DESCRIPTION gate.
> Show in a table what's in the description but not the diff / in the diff but not the description,
> and verdict FAIL/WARN/PASS."

## [Unverified]
- Accuracy of auto-comparing description ↔ diff is unmeasured.
