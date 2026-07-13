# Custom Workflows Fixture

Tests custom workflow execution, hook environment variables, and user-managed plan files.

## Coverage (v0.44.0 #6438)

- **PROJECT_NAME env var**: Pre-plan hook asserts `$PROJECT_NAME` is set correctly
- **Custom workflow steps**: `run` step executes before `init`/`plan`
- **Script validation**: POSIX shell script with clear pass/fail output
- **Custom plan path apply**: v0.46.0 regression coverage for Atlantis #6642

## Workflow Definition (in root atlantis.yaml)

```yaml
workflows:
  assert-project-name:
    plan:
      steps:
        - run: sh ../scripts/assert-project-name.sh
        - init
        - plan

  custom-plan-path:
    plan:
      steps:
        - run: terraform init -input=false -no-color
        - run: terraform plan -input=false -no-color -out=custom-atlantis.tfplan
        - run: test -f custom-atlantis.tfplan
        - run: echo ATLANTIS_E2E_CUSTOM_PLAN_CREATED
    apply:
      steps:
        - run: test -f custom-atlantis.tfplan
        - run: terraform apply -input=false -no-color custom-atlantis.tfplan
        - run: echo ATLANTIS_E2E_CUSTOM_PLAN_APPLY_OK
```

## E2E Behavior

1. Modify `project-name-env/main.tf` → triggers custom workflow
2. `assert-project-name.sh` checks `PROJECT_NAME=custom-workflow-env`
3. If env var missing or wrong → plan fails with "FAIL:" marker
4. If correct → prints "PASS:" and continues to init/plan

For `custom-plan-path`, the runner waits for the custom autoplan marker, posts
`atlantis apply -p custom-plan-path`, and requires the apply marker from a new comment.
