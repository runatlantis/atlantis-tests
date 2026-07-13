# Atlantis E2E Coverage Inventory

The upstream runner uses explicit lifecycle scenarios. `ScenarioPlanOnly` is the
default, `ScenarioPlanThenApply` is active only for named apply cases,
`ScenarioPlanThenReplanThenApply` requires a second plan generation, and
`ScenarioPlanThenApplyExpectFailure` protects negative apply cases. The
`ScenarioOnApplyLockPreservation` is an opt-in two-PR lifecycle. An `ApplyCommand`
on a plan-only case is intentionally not executed.

## Fixture Status

| Fixture | Coverage | Runner status |
|---------|----------|---------------|
| `standalone` | Basic single-project plan | Active on GitHub |
| `standalone` | Aggregate plan plus project comment marker | Active on GitLab |
| `standalone-with-workspace` | Workspace `staging` plan | Active on GitHub |
| `apply-regressions/builtin-autoplan-apply` | Built-in autoplan immediately followed by targeted built-in apply; Atlantis v0.46.0 regression [#6641](https://github.com/runatlantis/atlantis/issues/6641) | Active plan-then-apply on GitHub |
| `apply-regressions/builtin-replan-apply` | Built-in generation 1, built-in generation 2, then targeted apply of generation 2 | Active plan-replan-apply on GitHub |
| `apply-regressions/mixed-plan-mutation` | Custom pre-apply step mutates `$PLANFILE`; built-in apply must be rejected | Active expected-apply-failure on GitHub |
| `custom-workflows/custom-plan-path` | Run-only plan/apply using `custom-atlantis.tfplan`, never `$PLANFILE`; Atlantis v0.46.0 regression [#6642](https://github.com/runatlantis/atlantis/issues/6642) | Active targeted plan-then-apply on GitHub |
| `custom-workflows/custom-plan-replan` | Two run-only plan generations at `custom-replan.tfplan`, then targeted apply of generation 2 | Active plan-replan-apply on GitHub |
| `multi-projects/project1` | Explicit project selection | Active on GitHub |
| `multi-projects/shared-module` | `when_modified` fan-out to project1 and project2 | Active on GitHub |
| `multi-projects/project-with-workspace` | Project plus workspace | Opt-in |
| `autodiscovery/included-a` | Included autodiscovered project | Active on GitHub |
| `autodiscovery/explicit` | Explicit project precedence | Opt-in |
| `autodiscovery/included-b` | Second discovered project | Fixture-only |
| `autodiscovery/ignored` | `autodiscover.ignore_paths` | Fixture-only |
| `detection/terraform-json` | Configured `.tf.json` project | Active on GitHub |
| `detection/terraform-tf` | Standard `.tf` detection | Fixture-only |
| `detection/opentofu-basic` | OpenTofu distribution | Disabled; `tofu` is not guaranteed in CI |
| `custom-workflows/project-name-env` | `PROJECT_NAME` hook environment | Active on GitHub |
| `output/long-line` | Output longer than 64 KiB | Active on GitHub |
| `output/heredoc` | Heredoc and multiline rendering | Fixture-only |
| `output/failure` | Intentional plan failure marker | Disabled; needs manual-plan trigger support |
| `locking/on-apply-lock-preservation` | Apply-created repo lock survives a later plan and blocks a second PR | Opt-in on GitHub |
| `drift/local-file` | Drift remediation API | Disabled; needs `--enable-drift-detection` |

## Active v0.46.0 Regression Lifecycles

### Built-in autoplan to apply (#6641)

The runner waits for a successful terminal autoplan result, verifies
`atlantis/plan: builtin-autoplan-apply`, then immediately posts:

```text
atlantis apply -p builtin-autoplan-apply
```

It does not post a manual plan. The case requires a new aggregate apply result,
the successful `atlantis/apply: builtin-autoplan-apply` context, and a new comment
containing `ATLANTIS_E2E_BUILTIN_AUTOPLAN_APPLY_OK`.

### Custom plan path apply (#6642)

Both workflow stages contain only `run` steps. The plan is written to
`custom-atlantis.tfplan`; the workflow does not reference or create `$PLANFILE`.
The runner verifies the custom plan marker, posts:

```text
atlantis apply -p custom-plan-path
```

It then requires a new successful aggregate/project apply result and a new comment
containing `ATLANTIS_E2E_CUSTOM_PLAN_APPLY_OK`.

### Built-in and custom replan to latest apply

The two replan cases create `generation.auto.tfvars` with `GENERATION_1`, wait for
the initial autoplan, replace it with `GENERATION_2` in a second commit, and reject
the earlier terminal status/comment as stale. Targeted apply must expose the
generation-2 output. The custom case never creates or references `$PLANFILE`.

### Mixed managed-plan mutation

The mixed workflow mutates the convention-managed plan before its built-in apply
step. The runner requires a new aggregate apply failure containing `plan file changed`
and rejects any comment containing `ATLANTIS_E2E_MIXED_BUILTIN_APPLY_MUST_NOT_RUN`.

## Runner Guarantees

- Each lifecycle reuses the same clone, branch, mutation, push, pull-request, and cleanup setup.
- Repeated commands are distinguished by commit-status ID or update time, so a stale aggregate status cannot satisfy apply.
- GitHub cases can assert exact per-project plan and apply status contexts.
- Apply comment markers must occur after the apply command; an older matching comment is rejected.
- Replan markers must occur after the second push; the initial autoplan comment cannot satisfy them.
- Timeout diagnostics include the pull-request URL, aggregate status, relevant project statuses, and recent Atlantis comments.

## Follow-up Coverage

- Gitea is covered by realistic Atlantis parser/database integration tests, not the hosted E2E runner.
- Redis cluster/locking needs a Redis service in CI.
- Policy checks need a policy server or conftest setup.
- Drift needs the alpha server flag and a state mutation lifecycle.
- Automerge needs an isolated repository where merging E2E pull requests is safe.
- Visual heredoc rendering remains difficult to assert through commit statuses alone.
