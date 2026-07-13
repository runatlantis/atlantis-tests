# Apply Regression Fixtures

These projects exercise plan-to-apply lifecycles that regressed in Atlantis v0.46.0.

- `builtin-autoplan-apply` covers [Atlantis #6641](https://github.com/runatlantis/atlantis/issues/6641). Its built-in autoplan must persist `PullStatus`
  before the upstream runner immediately comments `atlantis apply -p builtin-autoplan-apply`.
- `custom-workflows/custom-plan-path` covers [Atlantis #6642](https://github.com/runatlantis/atlantis/issues/6642). It is documented with the custom
  workflow fixtures because both stages consist entirely of user-authored `run` steps.

Both cases are active in the upstream GitHub E2E runner. Neither case needs cloud
credentials or an external backend.
