resource "null_resource" "project1" {
  triggers = {
    marker = "atlantis-e2e-project1"
  }
}

output "project1_marker" {
  value = "project1-planned"
}
