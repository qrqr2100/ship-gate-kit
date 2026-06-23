Language-specific pattern — JavaScript ignored Promise / empty catch

Input diff: src/api/save.ts

Added code:
  async function saveRecord(data: Record) {
    db.write(data);          // no await
    cache.invalidate(data.id).catch(() => {});  // empty catch
  }

Gate verdict: CODE-DIFF FAIL.
Reason:
  1) db.write(data) — no await. A write error is ignored and the function proceeds.
  2) cache.invalidate().catch(() => {}) — empty catch. A cache invalidation failure is swallowed.
Overall: FAIL → add await + add error handling, then re-gate.
Explanation: the classic silent-failure path of JS async code. Even if TypeScript types pass, runtime behavior breaks.
