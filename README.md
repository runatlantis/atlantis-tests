# atlantis-tests

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_shield)

Integration test fixture repository for [Atlantis](https://github.com/runatlantis/atlantis) E2E tests. See workflow runs at https://github.com/runatlantis/atlantis/actions/workflows/test.yml

> **Note:** The upstream Atlantis E2E runner currently exercises only `standalone` and
> `standalone-with-workspace`. Other fixture directories are structured for future runner
> expansion and require a companion `runatlantis/atlantis` PR to become actively tested.

## Fixture Categories

| Directory | Purpose | Current Status |
|-----------|---------|----------------|
| `standalone/` | Basic single-project plan | Active in current runner |
| `standalone-with-workspace/` | Workspace-based planning | Active in current runner |
| `multi-projects/` | Explicit multi-project config, `-p` targeting, `when_modified` fan-out | Fixture only; requires companion runner change |
| `autodiscovery/` | Autodiscovery mode, `ignore_paths`, explicit precedence | Fixture only; requires companion runner change |
| `detection/` | `.tf`, `.tf.json`, OpenTofu distribution detection | Fixture only; requires companion runner change |
| `custom-workflows/` | Custom workflows, `PROJECT_NAME` hook env | Fixture only; requires companion runner change |
| `output/` | Plan output rendering (heredoc, long-line, failure text) | Fixture only |
| `locking/` | Repo lock lifecycle fixtures, including future `repo_locks.mode: on_apply` preservation coverage | Fixture only; requires companion runner/server config change |
| `drift/` | Drift detection API scaffolding (alpha) | Scaffold only |

## How E2E Works

1. E2E runner creates a webhook pointing Atlantis at the test repo
2. For each test case: clones repo → creates branch → mutates a `.tf` file → pushes → opens PR
3. Atlantis auto-plans via webhook
4. Runner polls commit status (`atlantis/plan`) until success/failure/timeout
5. Cleanup: close PR, delete branch, delete webhook

## Adding Fixtures

- Use `null_resource`, `terraform_data`, `local_file`, or `random` providers only
- No cloud credentials, no external backends
- Add unique output markers for E2E assertion (`output "xyz_marker" { value = "..." }`)
- Add explicit project entry in root `atlantis.yaml`
- Update `docs/coverage.md`

## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_large)
