resource "null_resource" "explicit" {
  triggers = {
    marker = "atlantis-e2e-explicit-override"
  }
}

output "explicit_marker" {
  value = "explicit-overrides-autodiscovery"
}
