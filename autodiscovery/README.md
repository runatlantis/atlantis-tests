# Autodiscovery Fixture

Tests Atlantis autodiscovery mode with `ignore_paths` and explicit project precedence.

## Coverage (v0.45.0 #6466)

- **Auto-discovered projects**: `included-a/` and `included-b/` have no explicit atlantis.yaml entry
- **Ignored paths**: `ignored/` is in `autodiscover.ignore_paths` — targeted `-d` commands should respect this
- **Explicit precedence**: `explicit/` has both auto-discoverable HCL AND an explicit project entry — explicit config wins

## atlantis.yaml Config

```yaml
autodiscover:
  mode: enabled
  ignore_paths:
    - "autodiscovery/ignored"
```

## E2E Behavior

1. Modify `included-a/main.tf` → Atlantis auto-discovers and plans it
2. `atlantis plan -d autodiscovery/ignored` → should be rejected/ignored
3. Modify `explicit/main.tf` → uses explicit project config, not discovered defaults
