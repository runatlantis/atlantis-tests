# Custom Plan Path Apply

Regression fixture for [runatlantis/atlantis#6642](https://github.com/runatlantis/atlantis/issues/6642),
introduced in Atlantis v0.46.0.

Both plan and apply use only custom `run` steps. The workflow writes
`custom-atlantis.tfplan`; it never references `$PLANFILE` and never creates Atlantis's
convention-named plan file.

The upstream runner targets the project explicitly because generic apply discovers
convention-named plan files by design:

```text
atlantis apply -p custom-plan-path
```

The apply must emit `ATLANTIS_E2E_CUSTOM_PLAN_APPLY_OK`.
