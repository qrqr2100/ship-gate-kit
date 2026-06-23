#!/usr/bin/env bash
# lint-gate.sh — Ship Gate Kit cross-check: non-LLM deterministic linter (judge kind: rule)
#
# Judges only the objectively decidable gates; abstains (N/A) on gates needing intent/meaning.
#   SECRET-SCAN  : YES   regex match -> FAIL on match
#   DEPENDENCY   : YES   look up added package names in the registry (404 -> FAIL)  [see dep_check]
#   CONFIG-CHANGE: PARTIAL  known risky key patterns only (e.g. permissions: write-all, 0.0.0.0/0)
#   SCOPE / CODE-DIFF / PR-DESCRIPTION : N/A (needs intent/meaning -> the LLM judge's job)
#
# [UNVERIFIED]: the regexes/lookups below are a starting point. False positives (.env.example placeholders,
#    test-fixture keys), false negatives (obfuscated keys), and npm-view 404 false positives (private/scoped
#    packages @org/...) are a live-measurement area. Real-project hit/false-positive rates are unmeasured.
#    Only set authoritative(anchor) once false positives are measured to be low enough.
#
# Usage: ./lint-gate.sh <files or diff files to check...>
set -uo pipefail

secret_scan() {
  grep -nE \
    -e 'sk_live_[0-9A-Za-z]{16,}' \
    -e 'sk-proj-[0-9A-Za-z_-]{16,}' \
    -e 'AKIA[0-9A-Z]{16}' \
    -e 'ghp_[0-9A-Za-z]{36}' \
    -e 'AIza[0-9A-Za-z_-]{35}' \
    -e '-----BEGIN (RSA|EC|OPENSSH|PRIVATE) KEY-----' \
    -e '(password|secret|token|api[_-]?key)[[:space:]]*[:=][[:space:]]*["'\''][^"'\'' ]{8,}' \
    "$@"
}

config_scan() {
  grep -nE \
    -e 'permissions:[[:space:]]*write-all' \
    -e '0\.0\.0\.0/0' \
    -e 'id-token:[[:space:]]*write' \
    "$@"
}

# DEPENDENCY: take added package names as args, look them up. 404/failure -> FAIL.
# e.g.: dep_check react-use-safe-debounce lodash
dep_check() {
  local pkg rc=0
  for pkg in "$@"; do
    if npm view "$pkg" version >/dev/null 2>&1; then
      echo "  DEPENDENCY [$pkg]: PASS (exists in registry)"
    else
      echo "  DEPENDENCY [$pkg]: FAIL (npm view failed/404 — suspect slopsquatting)"; rc=1
    fi
  done
  return $rc
}

echo "# Deterministic linter verdict (judge_id: linter)"

if secret_scan "$@" >/dev/null 2>&1; then
  echo "SECRET-SCAN: FAIL"
  secret_scan "$@" | sed 's/^/  /' || true
else
  echo "SECRET-SCAN: PASS (no regex match — obfuscation/false-negative possible)"
fi

if config_scan "$@" >/dev/null 2>&1; then
  echo "CONFIG-CHANGE: FAIL (known risky key pattern)"
  config_scan "$@" | sed 's/^/  /' || true
else
  echo "CONFIG-CHANGE: N/A (no known risky key pattern — rest is the LLM judge's job)"
fi

echo "SCOPE: N/A"
echo "CODE-DIFF: N/A"
echo "PR-DESCRIPTION: N/A"
echo "DEPENDENCY: (pass added package names to the dep_check function — see comment near top)"
