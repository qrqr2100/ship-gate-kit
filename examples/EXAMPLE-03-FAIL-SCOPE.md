Intent declared: "Fix the login bug — auth/login.ts only."
Actual diff files: auth/login.ts, utils/format.ts, package.json
Gate verdict: SCOPE FAIL.
Reason: 2 changes outside the declaration — utils/format.ts (logic change), package.json (dependency added).
Overall: FAIL → re-declare intent or remove out-of-declaration changes, then re-gate.
Explanation: the classic case of AI quietly touching adjacent files. Without comparing the file list, it ships as-is.
