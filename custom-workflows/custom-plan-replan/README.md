# Custom Plan Replan

This fixture extends the run-only custom-plan-path regression coverage for
[Atlantis #6642](https://github.com/runatlantis/atlantis/issues/6642).

Both stages contain only `run` steps. Plans are written to
`custom-replan.tfplan`; the workflow never references or creates `$PLANFILE`.
Each plan prints an explicit generation marker from `generation.auto.tfvars`.
The upstream runner plans generation 1, replans generation 2, and targets:

```text
atlantis apply -p custom-plan-replan
```

The apply must contain `ATLANTIS_E2E_CUSTOM_REPLAN_GENERATION_2` and
`ATLANTIS_E2E_CUSTOM_REPLAN_APPLY_OK`.

Status: active in the upstream GitHub plan-replan-apply scenario.
