resource "null_resource" "included_a" {
  triggers = {
    marker = "atlantis-e2e-autodiscovery-a"
  }
}

output "autodiscovery_a_marker" {
  value = "autodiscovery-a-planned"
}
