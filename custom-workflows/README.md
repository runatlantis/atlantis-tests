# Custom Workflows Fixture

Tests custom workflow execution and hook environment variables.

## Coverage (v0.44.0 #6438)

- **PROJECT_NAME env var**: Pre-plan hook asserts `$PROJECT_NAME` is set correctly
- **Custom workflow steps**: `run` step executes before `init`/`plan`
- **Script validation**: POSIX shell script with clear pass/fail output

## Workflow Definition (in root atlantis.yaml)

```yaml
workflows:
  assert-project-name:
    plan:
      steps:
        - run: sh ../scripts/assert-project-name.sh
        - init
        - plan
```

## E2E Behavior

1. Modify `project-name-env/main.tf` → triggers custom workflow
2. `assert-project-name.sh` checks `PROJECT_NAME=custom-workflow-env`
3. If env var missing or wrong → plan fails with "FAIL:" marker
4. If correct → prints "PASS:" and continues to init/plan
