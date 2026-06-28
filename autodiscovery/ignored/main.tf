resource "null_resource" "ignored" {
  triggers = {
    marker = "atlantis-e2e-should-be-ignored"
  }
}

output "ignored_marker" {
  value = "THIS-SHOULD-NOT-PLAN"
}
