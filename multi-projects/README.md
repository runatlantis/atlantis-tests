# Multi-Projects Fixture

Tests Atlantis explicit multi-project configuration.

## Coverage

- **Project targeting**: `atlantis plan -p project1`, `atlantis apply -p project2`
- **when_modified fan-out**: Changes to `shared-module/` trigger plans for both project1 and project2
- **Project + workspace**: `project-with-workspace` uses workspace=dev
- **Isolation**: Changing project1 should NOT plan project2 (unless shared-module changes)

## Projects

| Dir | Project Name | Workspace | Notes |
|-----|-------------|-----------|-------|
| `project1/` | project1 | default | Depends on shared-module via when_modified |
| `project2/` | project2 | default | Depends on shared-module via when_modified |
| `project-with-workspace/` | project-with-workspace | dev | Tests workspace + project name combo |
| `shared-module/` | — | — | Not a project; triggers fan-out when modified |

## E2E Behavior

1. Modify `project1/main.tf` → only project1 plans
2. Modify `shared-module/main.tf` → both project1 and project2 plan
3. `atlantis apply -p project1` → applies only project1
