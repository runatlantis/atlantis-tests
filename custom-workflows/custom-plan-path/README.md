# Custom Plan Path Apply

Regression fixture for [runatlantis/atlantis#6642](https://github.com/runatlantis/atlantis/issues/6642),
introduced in Atlantis v0.46.0.

Both plan and apply use only custom `run` steps. The workflow writes two user-managed
plan files below descendant directories:

- `generated/dev/atlantis.tfplan`
- `generated/staging/atlantis.tfplan`

It never references `$PLANFILE` and explicitly checks that Atlantis's root-level
`custom-plan-path-default.tfplan` convention plan does not exist.

The upstream runner uses generic apply to prove Atlantis assigns both descendant
artifacts to this single configured root project:

```text
atlantis apply
```

The apply verifies both plans are still present, applies the `generated/dev` plan,
and must emit `ATLANTIS_E2E_CUSTOM_PLAN_APPLY_OK` without creating a descendant
pseudo-project.
