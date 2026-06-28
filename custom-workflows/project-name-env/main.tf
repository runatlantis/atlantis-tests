resource "null_resource" "custom_workflow" {
  triggers = {
    marker = "atlantis-e2e-custom-workflow"
  }
}

output "custom_workflow_marker" {
  value = "custom-workflow-planned"
}
