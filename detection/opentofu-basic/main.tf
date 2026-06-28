resource "null_resource" "opentofu_project" {
  triggers = {
    marker = "atlantis-e2e-opentofu"
  }
}

output "opentofu_marker" {
  value = "planned-with-opentofu"
}
