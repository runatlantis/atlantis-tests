# atlantis-tests

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_shield)

Integration test fixture repository for [Atlantis](https://github.com/runatlantis/atlantis) E2E tests. See workflow runs at https://github.com/runatlantis/atlantis/actions/workflows/test.yml

## Fixture Categories

| Directory | Purpose | Active E2E |
|-----------|---------|------------|
| `standalone/` | Basic single-project plan | Yes |
| `standalone-with-workspace/` | Workspace-based planning | Yes |
| `multi-projects/` | Explicit multi-project config, `-p` targeting, `when_modified` fan-out | Yes |
| `autodiscovery/` | Autodiscovery mode, `ignore_paths`, explicit precedence | Yes |
| `detection/` | `.tf`, `.tf.json`, OpenTofu distribution detection | Yes |
| `custom-workflows/` | Custom workflows, `PROJECT_NAME` hook env | Yes |
| `output/` | Plan output rendering (heredoc, long-line, failure text) | Partial |
| `drift/` | Drift detection API scaffolding (alpha) | TODO |

## How E2E Works

1. E2E runner creates a webhook pointing Atlantis at the test repo
2. For each test case: clones repo → creates branch → mutates a `.tf` file → pushes → opens PR
3. Atlantis auto-plans via webhook
4. Runner polls commit status (`atlantis/plan`) until success/failure/timeout
5. Optional: runner issues apply command and checks apply status
6. Cleanup: close PR, delete branch, delete webhook

## Adding Fixtures

- Use `null_resource`, `terraform_data`, `local_file`, or `random` providers only
- No cloud credentials, no external backends
- Add unique output markers for E2E assertion (`output "xyz_marker" { value = "..." }`)
- Add explicit project entry in root `atlantis.yaml`
- Update `docs/coverage.md`

## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Frunatlantis%2Fatlantis-tests?ref=badge_large)
