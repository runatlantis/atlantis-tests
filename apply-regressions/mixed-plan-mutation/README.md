# Mixed Managed Plan Mutation

Negative regression fixture for the plan-hash protection introduced by
[Atlantis #6605](https://github.com/runatlantis/atlantis/pull/6605).

The plan uses Atlantis's built-in convention-managed file. Its apply workflow
first mutates `$PLANFILE`, then invokes the built-in `apply` step. Atlantis must
reject the changed plan immediately before the built-in runner executes.

Expected evidence:

- aggregate apply failure;
- an error containing `plan file changed`;
- no `ATLANTIS_E2E_MIXED_BUILTIN_APPLY_MUST_NOT_RUN` marker.

Status: active only through the upstream expected-apply-failure scenario.
