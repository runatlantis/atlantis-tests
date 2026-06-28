# Output Rendering Fixture

Tests Terraform plan output rendering in Atlantis comments and job page.

## Coverage

- **Heredoc/multiline diffs** (v0.44.1 #6561): Multi-line string with special chars
- **Long single-line output** (v0.44.1 #6544): String exceeding 64KiB
- **Failure text on job page** (v0.45.0 #6414): Intentional failure with unique marker

## Projects

| Dir | Behavior | Current Status |
|-----|----------|----------------|
| `heredoc/` | Generates multiline plan diff | Fixture only |
| `long-line/` | Generates ~80 KiB single-line output | Fixture only |
| `failure/` | Intentionally fails with ATLANTIS_E2E_FAILURE_MARKER | Fixture only; requires companion runner support |

## Notes

- `failure/` has `autoplan.enabled: false` — only triggered by targeted command
- `failure/` uses workflow `intentional-failure` that echoes a marker then exits 1
- A companion runner can trigger this fixture explicitly and assert the stable marker string appears in failure output/comment, but the current upstream runner does not execute it
- `heredoc/` and `long-line/` use `terraform_data` (requires Terraform 1.4+)
