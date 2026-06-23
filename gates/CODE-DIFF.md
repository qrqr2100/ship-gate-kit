# GATE: CODE-DIFF — risky code pattern

## Purpose
Judge the "must not ship" risky code patterns in a diff before shipping.
(This is not a quality/refactor suggestion — it's a **can this go out** decision.)

## Checklist (common — language-agnostic)
- [ ] Debug leftovers: `print`/`console.log`/`debugger`/`TODO turn off now`
      → production log pollution / info exposure.
- [ ] Unhandled error paths: empty `catch{}`, ignored Promise, possible divide-by-zero
      → silent failures corrupt data/state.
- [ ] Hardcoded environment values: local paths, ports, URLs, test accounts
      → breaks in other environments.
- [ ] Large blocks of commented-out code left behind
      → unclear intent, review burden.
- [ ] Reverted changes / conflict markers (`<<<<<<<`)
      → merge accidents.

## Language-specific patterns — only the real differences

Common items ("empty catch", "debug leftovers") are written once above. Below covers only patterns whose **shape actually differs** by language.

### Python — empty except, swallowing errors with output

```python
# FAIL — catches every exception and does nothing
try:
    result = risky_call()
except:
    pass
```

```python
# FAIL — swallows the error with a log/print and keeps going
try:
    result = risky_call()
except Exception as e:
    print(f"error: {e}")   # execution continues
```

Check point: is the body of an `except:` / `except Exception` block just `pass` / `print` / `logging.debug`?

### JavaScript / TypeScript — ignored Promise, empty catch

```javascript
// FAIL — ignores the returned Promise (no await, no .catch)
fetchData();   // return value and error ignored

// FAIL — empty .catch
fetchData().catch(() => {});
```

```typescript
// FAIL — missing await in an async function
async function save() {
    db.write(data);   // no await — the error disappears
}
```

Check point: a Promise returned without `await` inside an `async` function, or an empty `.catch(() => {})` handler.

### Go — discarded err return value

```go
// FAIL — discards err with _
result, _ := os.ReadFile("config.json")

// FAIL — ignores the Close error of a deferred file
defer f.Close()   // no err on Close — a flush failure is buried
```

```go
// PASS
result, err := os.ReadFile("config.json")
if err != nil {
    return fmt.Errorf("failed to read config: %w", err)
}
```

Check point: `_` used alone in the error slot without the `_, err` pattern / `defer f.Close()` with err unhandled.

### Rust — unwrap()/expect() left in production

```rust
// FAIL — unwrap() panics on None/Err. In production, replace with error propagation
let config = std::fs::read_to_string("config.toml").unwrap();

// WARN (when not test code) — expect() also panics
let val = map.get("key").expect("key must exist");
```

Check point: is `.unwrap()` / `.expect()` outside `#[cfg(test)]`? If so, at least WARN (unless a comment states a panic is logically impossible).

## Verdict criteria
- **FAIL** — conflict markers, unhandled critical error paths, hardcoded secret-ish values, Go `_` err discard (core path). Don't ship.
- **WARN** — debug leftovers, commented code, Rust `.unwrap()` in production, etc. — possibly harmless or intentional. Decide whether to proceed.
- **PASS** — none of the above.

## How to hand it to Claude Code
> "Apply the CODE-DIFF gate to this code (a diff, file, or snippet). List common risky patterns and language-specific patterns (Python empty except, JS ignored Promise, Go _ err discard, Rust unwrap in production) with lines, classify by severity (FAIL/WARN), and give an overall verdict only. Don't fix the code."

## [Unverified]
- Real-project hit rate of the language-specific patterns is unmeasured.
