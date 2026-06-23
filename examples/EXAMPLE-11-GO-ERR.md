Language-specific pattern — Go discarding the err return value with _

Input diff: internal/store/file.go

Added code:
  func WriteConfig(cfg Config) {
      data, _ := json.Marshal(cfg)   // err discarded
      _ = os.WriteFile("config.json", data, 0644)
  }

Gate verdict: CODE-DIFF FAIL.
Reason:
  1) json.Marshal err discarded — on Marshal failure, data is nil, then nil is passed to WriteFile.
  2) os.WriteFile err discarded — a file write failure is ignored.
Overall: FAIL → return/handle both errors, then re-gate.
Explanation: in Go, `_` is a convention for intentional ignoring, but discarding write/marshal failures is a data-loss path.
      Even with the "always handle err" convention, AI misses it.
