# atlantis-tests

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_shield)

Integration test fixture repository for [Atlantis](https://github.com/runatlantis/atlantis) E2E tests. See workflow runs at https://github.com/runatlantis/atlantis/actions/workflows/test.yml

The upstream Atlantis E2E runner has explicit plan-only, plan-then-apply, and
on-apply lock-preservation scenarios. Cases marked active below run in the regular
GitHub or GitLab E2E jobs; opt-in cases require `E2E_OPT_IN=1`.

## Fixture Categories

| Directory | Purpose | Current Status |
|-----------|---------|----------------|
| `standalone/` | Basic single-project plan | Active on GitHub and GitLab |
| `standalone-with-workspace/` | Workspace-based planning | Active on GitHub |
| `apply-regressions/` | Immediate apply, built-in replan, and managed-plan mutation regressions | Active success and expected-failure lifecycles on GitHub |
| `multi-projects/` | Explicit projects and `when_modified` fan-out | Active project/fan-out cases; workspace case opt-in |
| `autodiscovery/` | Autodiscovery and explicit precedence | Included project active; explicit precedence opt-in |
| `detection/` | `.tf`, `.tf.json`, OpenTofu detection | `.tf.json` active; OpenTofu disabled; others fixture-only |
| `custom-workflows/` | Hook environment and user-managed plan paths | Nested custom-path generic apply and custom replan lifecycles active on GitHub |
| `output/` | Plan output rendering | Long-line active; failure disabled; heredoc fixture-only |
| `locking/` | `repo_locks.mode: on_apply` preservation | Opt-in two-PR plan/apply lifecycle |
| `drift/` | Drift detection API scaffolding | Disabled until the server flag is available in E2E |

## How E2E Works

1. E2E runner creates a webhook pointing Atlantis at the test repo
2. For each test case: clones repo → creates branch → mutates a Terraform file → pushes → opens PR
3. Atlantis auto-plans via webhook
4. Runner polls a new `atlantis/plan` result and asserts configured project statuses/comments
5. Replan cases push a second generation, require a new plan result/comment, and only then post targeted apply
6. Apply cases reject stale status results and assert either a new success marker or the configured failure evidence
7. Cleanup closes the PR, deletes the branch, and deletes the webhook

## Adding Fixtures

- Use `null_resource`, `terraform_data`, `local_file`, or `random` providers only
- No cloud credentials, no external backends
- Add unique output markers for E2E assertion (`output "xyz_marker" { value = "..." }`)
- Add explicit project entry in root `atlantis.yaml`
- Update `docs/coverage.md`
- Run `scripts/validate-fixture-consistency.sh`; when developing both repositories,
  pass the upstream `e2e/testcase.go` path to validate cross-repository references

## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_large)
