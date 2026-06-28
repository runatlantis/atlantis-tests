resource "null_resource" "project2" {
  triggers = {
    marker = "atlantis-e2e-project2"
  }
}

output "project2_marker" {
  value = "project2-planned"
}
