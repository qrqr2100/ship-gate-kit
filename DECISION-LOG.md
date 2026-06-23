# DECISION-LOG — Ship Gate Kit design rationale

D1. Compressed gates to 6 (from 8): examples must back the gates for the kit to have substance.
    RELEASE-NOTES and DOCUMENT were demoted to templates instead of dedicated gates.

D2. Axis = 'ship go/no-go decision', not 'editing (polishing text)'. End with PASS/WARN/FAIL.
    Reason: so it doesn't become a writing-polish editor kit or a copy-paste knockoff — this kit doesn't "fix", it "decides whether it can ship".

D3. Cited numbers (slopsquatting %, secret-leak multiples, AI-bug multiples) are **excluded** from the body.
    They are all external self-reports/external measurements, not this kit's own measurements.
    The phenomena are kept only as qualitative statements ("reported real phenomena").

D4. Gate "hit rate" is not claimed. The gate provides a "decision procedure";
    how much it actually catches is [unverified]. Not stated as fact until empirical data exists.

D5. Why not auto-block / boundary with dedicated tools.

    This kit's verdict criteria are designed on the assumption that "a human runs it in 1–2 minutes inside the Claude Code conversation".
    If that premise breaks, the kit's differentiator breaks too.

    Auto-blocking (CI gating) serves a different need:
    - forced run on every build / merge blocking / audit logs / real-time registry lookups
    The things that meet that need are the dedicated tools:
    - gitleaks / truffleHog — full-history, entropy-based secret detection, CI integration
    - Socket / Snyk — package supply chain, CVE, license automation

    If you wire this kit into CI as an auto-block:
    a) the dedicated tools are far better → this kit becomes unnecessary.
    b) this kit's limits (no-internet environments, incomplete language patterns, unmeasured hit rate) become the blocking criteria → false-positive/malfunction risk.
    c) the "first filter inside the AI build loop" positioning disappears.

    So this kit does not recommend CI auto-blocking. If you want CI auto-blocking, use the dedicated tools.
    This kit is the step before: a procedure a person runs themselves before sending.
