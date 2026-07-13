# Built-in Replan to Apply

This credential-free fixture protects the plan-generation lifecycle adjacent to
[Atlantis #6641](https://github.com/runatlantis/atlantis/issues/6641) and
[Atlantis #6642](https://github.com/runatlantis/atlantis/issues/6642).

The upstream runner creates `generation.auto.tfvars` with generation 1, waits for
autoplan, overwrites it with generation 2 in a second commit, waits for the new
plan, and then targets:

```text
atlantis apply -p builtin-replan-apply
```

The apply comment must contain `ATLANTIS_E2E_BUILTIN_REPLAN_GENERATION_2`, proving
that the second convention-managed plan—not the first generation—was applied.

Status: active in the upstream GitHub plan-replan-apply scenario.
