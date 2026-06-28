# Drift Detection Fixture (Scaffold)

Alpha drift detection/remediation API scaffolding (v0.45.0 #6360).

## Status: TODO

This fixture provides the Terraform configuration but does NOT have active E2E coverage yet.

## Requirements for Active Coverage

1. Atlantis must be started with `--enable-drift-detection`
2. E2E must plan/apply the `local_file` resource to create initial state
3. E2E must externally modify `drift-target.txt` to induce drift
4. E2E must call drift detection API with `X-Atlantis-Token`
5. E2E must verify auth failures without token
6. E2E must verify path/repo validation rejects invalid inputs

## Design Notes

- Uses `local_file` provider (no cloud credentials needed)
- Drift can be induced by writing directly to `drift-target.txt` after apply
- Remediation apply should only work when `has_drift: true` is cached
- Do NOT enable `--enable-drift-remediation` in generic E2E
