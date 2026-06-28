# Atlantis E2E Coverage Inventory

> **Note:** As of this PR, the upstream Atlantis E2E runner (`runatlantis/atlantis/e2e/main.go`)
> actively exercises only `standalone` and `standalone-with-workspace`. All other fixture
> directories are structured for future runner expansion and require a companion
> `runatlantis/atlantis` E2E runner PR to become actively tested.

## Fixture Status

| Fixture | Atlantis Feature | Release Motivation | Current Status | Notes |
|---------|-----------------|-------------------|----------------|-------|
| `standalone` | Basic single-project plan/apply | Original smoke test | Active in current runner | Plan-only verification |
| `standalone-with-workspace` | Workspace-based planning | Original smoke test | Active in current runner | workspace=staging |
| `multi-projects/project1` | Explicit multi-project config | General coverage | Fixture only; requires companion runner change | `-p project1` targeting |
| `multi-projects/project2` | Explicit multi-project config | General coverage | Fixture only; requires companion runner change | `-p project2` targeting |
| `multi-projects/project-with-workspace` | Project + workspace combo | General coverage | Fixture only; requires companion runner change | workspace=dev |
| `multi-projects/shared-module` | `when_modified` fan-out | General coverage | Fixture only; requires companion runner change | Triggers project1+project2 via when_modified |
| `autodiscovery/included-a` | Autodiscovery mode:enabled | v0.45.0 #6466 | Fixture only; requires companion runner change | Auto-discovered, not in explicit projects |
| `autodiscovery/included-b` | Autodiscovery mode:enabled | v0.45.0 #6466 | Fixture only; requires companion runner change | Second auto-discovered project |
| `autodiscovery/ignored` | `autodiscover.ignore_paths` | v0.45.0 #6466 | Fixture only; requires companion runner change | Targeted `-d` should respect ignore |
| `autodiscovery/explicit` | Explicit overrides discovery | v0.45.0 #6466 | Fixture only; requires companion runner change | Explicit project takes precedence |
| `detection/terraform-tf` | `.tf` file detection | v0.44.1 #6455 | Fixture only; requires companion runner change | Standard terraform project |
| `detection/terraform-json` | `.tf.json` detection | v0.44.1 #6455 | Fixture only; requires companion runner change | JSON-format terraform |
| `detection/opentofu-basic` | OpenTofu distribution | v0.45.0 #6597 | Fixture only; requires companion runner change | `terraform_distribution: opentofu` |
| `custom-workflows/project-name-env` | PROJECT_NAME in hooks | v0.44.0 #6438 | Fixture only; requires companion runner change | Custom workflow asserts env var |
| `output/heredoc` | Heredoc/multiline diffs | v0.44.1 #6561 | Fixture only | Plan output rendering |
| `output/long-line` | Long single-line output (>64 KiB) | v0.44.1 #6544 | Fixture only | ~88 KiB single-line value |
| `output/failure` | Failure text on job page | v0.45.0 #6414 | Fixture only; requires companion runner change | Intentional failure with marker |
| `drift/local-file` | Drift detection API scaffold | v0.45.0 #6360 | Scaffold only | Needs `--enable-drift-detection` server flag |

## Release Coverage Matrix

| Release | Feature/Fix | Coverage Status |
|---------|------------|----------------|
| v0.45.0 | Drift detection/remediation APIs | Scaffold only — needs `--enable-drift-detection` and dedicated E2E mode |
| v0.45.0 | Localization (`--language`) | Follow-up — requires server-side config, not repo-level |
| v0.45.0 | Automerge controls | Follow-up — risky in live test repo, needs isolated fork |
| v0.45.0 | `autodiscover.ignore_paths` on targeted `-d` | Fixture only; requires companion runner change |
| v0.45.0 | OpenTofu distribution detection | Fixture only; requires companion runner change |
| v0.45.0 | `.tf`, `.tf.json`, `terragrunt.hcl` detection | Fixture only (`.tf`, `.tf.json`); Terragrunt deferred (not in CI) |
| v0.45.0 | Path-hardening (CWE-22) | Follow-up — requires companion runner negative test case |
| v0.45.0 | Slack payload improvements | Follow-up — needs mock HTTP receiver |
| v0.45.0 | Streamed failure text to job page | Fixture only; requires companion runner change |
| v0.44.1 | Apply lock fail-closed | Follow-up — needs Redis/lock backend in CI |
| v0.44.1 | No-change apply status (`up to date`) | Follow-up — requires apply verification in runner |
| v0.44.1 | Stale `.tfplan` cleanup | Follow-up — requires branch-update scenario in runner |
| v0.44.1 | Heredoc/multiline diff rendering | Fixture only — visual, hard to assert programmatically |
| v0.44.1 | `to forget` plan statistics | Fixture only — needs stateful resource |
| v0.44.1 | Long line (>64 KiB) output | Fixture only |
| v0.44.0 | Sticky policy approvals | Follow-up — needs policy server config |
| v0.44.0 | Redis cluster support | Follow-up — needs Redis in CI |
| v0.44.0 | `PROJECT_NAME` hook env | Fixture only; requires companion runner change |

## Current E2E Runner Architecture

The current Atlantis E2E runner (`runatlantis/atlantis/e2e/main.go`) has two hardcoded test cases:

```go
var projectTypes = []Project{
    {"standalone", "atlantis apply -d standalone"},
    {"standalone-with-workspace", "atlantis apply -d standalone-with-workspace -w staging"},
}
```

Each test: clones repo → creates branch → writes `.tf` file → pushes → creates PR → polls `atlantis/plan` commit status until success/failure/timeout → cleans up.

**Limitations of current runner:**
- Only checks plan status, never issues apply
- No comment text assertion
- No project-name targeting (`-p`)
- No negative/failure test cases
- No autodiscovery or custom workflow verification

## Companion Runner Changes Needed (`runatlantis/atlantis`)

To activate the new fixtures, the runner needs:

1. Richer test-case table with: Name, Dir, Workspace, ProjectName, FilesToMutate, ExpectedStatus, ApplyCommand, ExpectedCommentSubstring, ExpectFailure, VCS
2. New test cases for each fixture category
3. Apply verification (issue apply, check status)
4. Comment assertion (fetch PR comments, match substrings)
5. Negative test cases (expected failures, ignored paths)

## Follow-up Items (Cannot Be Covered by Fixtures Alone)

1. **Localization** — needs `--language`/`--language-config-file` server flag
2. **Automerge** — needs isolated fork to safely merge test PRs
3. **Redis cluster locking** — needs Redis service in CI
4. **Slack notifications** — needs mock HTTP receiver
5. **GitHub App checkout** — needs App credentials with fork access
6. **Sticky policy approvals** — needs conftest/policy server
7. **Drift API full cycle** — needs `--enable-drift-detection` and local state mutation
