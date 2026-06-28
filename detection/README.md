# Detection Fixture

Tests Atlantis project directory detection for different file formats and distributions.

## Coverage

- **`.tf` files** (v0.44.1 #6455): Standard HCL terraform project
- **`.tf.json` files** (v0.44.1 #6455): JSON-format terraform configuration
- **OpenTofu** (v0.45.0 #6597): Project with `terraform_distribution: opentofu`

## Projects

| Dir | Format | Distribution | Notes |
|-----|--------|-------------|-------|
| `terraform-tf/` | `.tf` | terraform | Standard detection |
| `terraform-json/` | `.tf.json` | terraform | JSON config detection |
| `opentofu-basic/` | `.tf` | opentofu | `terraform_distribution: opentofu` in atlantis.yaml |

## E2E Behavior

1. Modify `terraform-json/main.tf.json` → Atlantis detects and plans the JSON project
2. Modify `opentofu-basic/main.tf` → Atlantis uses OpenTofu binary for plan
3. OpenTofu fixture requires OpenTofu available in the Atlantis server PATH
