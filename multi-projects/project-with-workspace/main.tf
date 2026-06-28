variable "environment" {
  default = "dev"
}

resource "null_resource" "workspace_project" {
  triggers = {
    env    = var.environment
    marker = "atlantis-e2e-workspace-${var.environment}"
  }
}

output "workspace_marker" {
  value = "workspace-${var.environment}-planned"
}
