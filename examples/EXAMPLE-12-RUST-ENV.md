Language-specific pattern — Rust env!() macro misuse

Input diff: src/config.rs

Added code:
  const API_ENDPOINT: &str = env!("SERVICE_ENDPOINT");
  const API_KEY: &str = env!("SERVICE_API_KEY");

Gate verdict: SECRET-SCAN WARN → FAIL depending on context.
Reason: env!() is a compile-time macro. If a real key is set in the CI build environment,
      it gets baked into the release binary.
      For an API_KEY use, replace with the runtime std::env::var().
Overall: WARN (confirm whether the key is in the build environment) / FAIL if confirmed.
Explanation: a Rust compile-time trait. Not knowing the difference between std::env::var() and env!()
      leads to "I set it as an env var, why is it in the binary?"
