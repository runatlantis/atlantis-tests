# Output Rendering Fixture

Tests Terraform plan output rendering in Atlantis comments and job page.

## Coverage

- **Heredoc/multiline diffs** (v0.44.1 #6561): Multi-line string with special chars
- **Long single-line output** (v0.44.1 #6544): String exceeding 64KiB
- **Failure text on job page** (v0.45.0 #6414): Intentional failure with unique marker

## Projects

| Dir | Behavior | Active E2E |
|-----|----------|------------|
| `heredoc/` | Generates multiline plan diff | Fixture only |
| `long-line/` | Generates very long output line | Fixture only |
| `failure/` | Intentionally fails with ATLANTIS_E2E_FAILURE_MARKER | Yes (negative test) |

## Notes

- `failure/` has `autoplan.enabled: false` — only triggered by targeted command
- `failure/` uses workflow `intentional-failure` that echoes a marker then exits 1
- E2E asserts the marker string appears in the failure output/comment
- `heredoc/` and `long-line/` use `terraform_data` (requires Terraform 1.4+)
