# Atlantis E2E Coverage Inventory

## Current Fixtures

| Fixture | Atlantis Feature | Release Motivation | Active E2E? | Notes |
|---------|-----------------|-------------------|-------------|-------|
| `standalone` | Basic single-project plan/apply | Original smoke test | Yes (plan only) | No apply verification |
| `standalone-with-workspace` | Workspace-based planning | Original smoke test | Yes (plan only) | workspace=staging |
| `multi-projects/project1` | Explicit multi-project config | General coverage | **Yes** | `-p project1` targeting |
| `multi-projects/project2` | Explicit multi-project config | General coverage | **Yes** | `-p project2` targeting |
| `multi-projects/project-with-workspace` | Project + workspace combo | General coverage | **Yes** | workspace=dev |
| `multi-projects/shared-module` | `when_modified` fan-out | General coverage | Fixture only | Needs E2E case that modifies shared module |
| `autodiscovery/included-a` | Autodiscovery mode:enabled | v0.45.0 #6466 | **Yes** | Auto-discovered, not in explicit projects |
| `autodiscovery/included-b` | Autodiscovery mode:enabled | v0.45.0 #6466 | Fixture only | Second auto-discovered project |
| `autodiscovery/ignored` | `autodiscover.ignore_paths` | v0.45.0 #6466 | **Yes** (negative) | Targeted `-d` should respect ignore |
| `autodiscovery/explicit` | Explicit overrides discovery | v0.45.0 #6466 | **Yes** | Explicit project takes precedence |
| `detection/terraform-tf` | `.tf` file detection | v0.44.1 #6455 | **Yes** | Standard terraform project |
| `detection/terraform-json` | `.tf.json` detection | v0.44.1 #6455 | **Yes** | JSON-format terraform |
| `detection/opentofu-basic` | OpenTofu distribution | v0.45.0 #6597 | **Yes** | `terraform_distribution: opentofu` |
| `custom-workflows/project-name-env` | PROJECT_NAME in hooks | v0.44.0 #6438 | **Yes** | Custom workflow asserts env var |
| `output/heredoc` | Heredoc/multiline diffs | v0.44.1 #6561 | Fixture only | Plan output rendering |
| `output/long-line` | Long single-line output | v0.44.1 #6544 | Fixture only | 64KiB+ line preservation |
| `output/failure` | Failure text on job page | v0.45.0 #6414 | **Yes** (negative) | Intentional failure with marker |
| `drift/local-file` | Drift detection API scaffold | v0.45.0 #6360 | TODO | Needs `--enable-drift-detection` |

## Release Coverage Matrix

| Release | Feature/Fix | Coverage Status |
|---------|------------|----------------|
| v0.45.0 | Drift detection/remediation APIs | Fixture scaffold only — needs dedicated E2E mode with `--enable-drift-detection` |
| v0.45.0 | Localization (`--language`) | Follow-up — requires server-side config, not repo-level |
| v0.45.0 | Automerge controls | Follow-up — risky in live test repo, needs isolated fork |
| v0.45.0 | `autodiscover.ignore_paths` on targeted `-d` | **Active** via `autodiscovery/ignored` negative case |
| v0.45.0 | OpenTofu distribution detection | **Active** via `detection/opentofu-basic` |
| v0.45.0 | `.tf`, `.tf.json`, `terragrunt.hcl` detection | **Active** (`.tf`, `.tf.json`); Terragrunt deferred (not in CI) |
| v0.45.0 | Path-hardening (CWE-22) | **Active** negative case in E2E runner |
| v0.45.0 | Slack payload improvements | Follow-up — needs mock HTTP receiver |
| v0.45.0 | Streamed failure text to job page | **Active** via `output/failure` |
| v0.44.1 | Apply lock fail-closed | Follow-up — needs Redis/lock backend in CI |
| v0.44.1 | No-change apply status (`up to date`) | **Active** via apply-after-plan E2E case |
| v0.44.1 | Stale `.tfplan` cleanup | Covered by branch-update E2E case design |
| v0.44.1 | Heredoc/multiline diff rendering | Fixture only — visual, hard to assert |
| v0.44.1 | `to forget` plan statistics | Fixture only — needs stateful resource |
| v0.44.1 | Long line (>64KiB) output | Fixture only |
| v0.44.0 | Sticky policy approvals | Follow-up — needs policy server config |
| v0.44.0 | Redis cluster support | Follow-up — needs Redis in CI |
| v0.44.0 | `PROJECT_NAME` hook env | **Active** via `custom-workflows/project-name-env` |

## E2E Architecture

The E2E runner (`runatlantis/atlantis/e2e/main.go`) uses a test-case table:

```go
var projectTypes = []TestCase{...}
```

Each test case specifies:
- Name, Dir, Workspace, ProjectName
- Files to mutate
- Expected plan/apply status
- Optional comment substring assertions
- Whether failure is expected
- VCS applicability (GitHub, GitLab, both)

## Follow-up Items (Cannot Be Covered by Fixtures Alone)

1. **Localization** — needs `--language`/`--language-config-file` server flag
2. **Automerge** — needs isolated fork to safely merge test PRs
3. **Redis cluster locking** — needs Redis service in CI
4. **Slack notifications** — needs mock HTTP receiver
5. **GitHub App checkout** — needs App credentials with fork access
6. **Sticky policy approvals** — needs conftest/policy server
7. **Drift API full cycle** — needs `--enable-drift-detection` and local state mutation
