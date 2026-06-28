resource "null_resource" "included_b" {
  triggers = {
    marker = "atlantis-e2e-autodiscovery-b"
  }
}

output "autodiscovery_b_marker" {
  value = "autodiscovery-b-planned"
}
