# GATE: SECRET-SCAN — secret / credential exposure

## Purpose
Block API keys, tokens, passwords, and connection strings from shipping hardcoded or exposed
in your output (diff, config, logs, docs).

## How it gets missed
- AI hardcodes a real key into example code to demo behavior.
- You put `.env` in `.gitignore` but copy the same value into another file.
- A token is left in a debug log or comment.

## Checklist (common — language-agnostic)

- [ ] Are known key prefixes like `sk-`, `ghp_`, `xox`, `AKIA`, `AIza`, `ya29.` in the diff?
      → these prefixes are assumed valid secrets and get abused immediately.
- [ ] Is a 32+ char random alphanumeric/Base64 string hardcoded as a variable value?
      → likely a token/hash/secret. Move it to an environment variable.
- [ ] Is there a literal on the right of `password=`, `secret=`, `token=`, `apikey=`?
      → plaintext secret in config/connection string. It leaks all the way to CI logs.
- [ ] Was a `.env`, `*.pem`, `*.key`, or `credentials.json` **added** in the diff?
      → a secret file in a commit stays in history forever.
- [ ] Is there a real-looking key in a comment, example, or test fixture?
      → "example" or not, a real key is a leak.

## Language-specific patterns — only the real differences

Prefixes (`sk-`, `ghp_`, etc.) are language-agnostic. Below are the places where **how a secret gets baked into code** actually differs by language.

### Python
Misusing an environment-variable fallback as a hardcode:

```python
# FAIL — the second argument becomes a real-value fallback
API_KEY = os.environ.get("OPENAI_KEY", "sk-proj-abc123realkey")
```

```python
# PASS — no fallback, returns None, raises explicitly if missing
API_KEY = os.environ.get("OPENAI_KEY")
if not API_KEY:
    raise EnvironmentError("OPENAI_KEY environment variable is not set.")
```

Check point: does the second argument of `os.environ.get()` hold a real-format string rather than a dummy?

### JavaScript / TypeScript
A real value placed in a `process.env` short-circuit fallback:

```javascript
// FAIL — when the env var is unset, the real key is exposed as fallback
const apiKey = process.env.OPENAI_KEY || "sk-proj-abc123realkey";
```

```javascript
// PASS — no fallback, throws explicitly if unset
const apiKey = process.env.OPENAI_KEY;
if (!apiKey) throw new Error("OPENAI_KEY is not set");
```

Check point: is there a real-format string (not a dummy) on the right of `||`?

### Go
Baked into a const block or struct tag:

```go
// FAIL — real key literal in a const block
const (
    APIKey = "sk-proj-abc123realkey"
)
```

Go has no `os.Getenv()` fallback syntax, so the second-argument pattern doesn't exist, but literals baked into **const blocks / struct init / test fixtures** are common instead. Check point: literal string values inside a `const (...)` block.

### Rust
The `env!()` macro reads env vars at compile time — the build environment's value gets **baked into the binary**:

```rust
// FAIL risk — the build-time env var is included in the binary
// if the CI build environment has a real key, it's exposed in the release binary
const API_KEY: &str = env!("OPENAI_KEY");
```

```rust
// PASS — read at runtime, not baked into the binary
let api_key = std::env::var("OPENAI_KEY")
    .expect("OPENAI_KEY environment variable required");
```

Check point: use of `env!()` + can a real key end up in the build environment for that variable?

## Verdict criteria
- **FAIL** — any item above exposes a "looks like a real secret" value. Don't ship.
- **WARN** — looks like a secret but is an obvious dummy (`xxxx`, `your-key-here`) or uncertain. A human confirms once.
- **PASS** — no signs of secret exposure.

## How to hand it to Claude Code
> "Apply the SECRET-SCAN gate to this code (a diff, file, or snippet). Using the common checklist and language-specific patterns (Python fallback, JS short-circuit, Go const block, Rust env! macro), list exposure candidates with line and file, judge each as a real secret vs a dummy, and verdict FAIL/WARN/PASS. Don't fix the code."

## When to move to a dedicated tool
This gate is a first pass. For full-history scanning and automation:
- gitleaks: `gitleaks detect --source .` (includes Git history)
- truffleHog: entropy-based scanning, built-in patterns for many providers

## [Unverified]
- Real-project hit rate of the language-specific patterns is unmeasured.
- Integration with dedicated scanners is not tested in a real environment.
