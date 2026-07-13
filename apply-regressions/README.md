# Apply Regression Fixtures

These projects exercise plan-to-apply lifecycles that regressed in Atlantis v0.46.0.

- `builtin-autoplan-apply` covers [Atlantis #6641](https://github.com/runatlantis/atlantis/issues/6641). Its built-in autoplan must persist `PullStatus`
  before the upstream runner immediately comments `atlantis apply -p builtin-autoplan-apply`.
- `builtin-replan-apply` requires a second built-in plan generation and proves the
  targeted apply consumes generation 2.
- `mixed-plan-mutation` deliberately changes the managed plan between a custom
  pre-apply step and the built-in apply. It is an active expected-failure case.
- `custom-workflows/custom-plan-path` covers [Atlantis #6642](https://github.com/runatlantis/atlantis/issues/6642). It is documented with the custom
  workflow fixtures because both stages consist entirely of user-authored `run` steps.

All cases are credential-free and have explicit upstream lifecycle status in
`docs/coverage.md`.
