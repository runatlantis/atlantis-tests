resource "null_resource" "failure_test" {
  triggers = {
    marker = "atlantis-e2e-failure-output"
  }
}

output "failure_marker" {
  value = "FAILURE_MARKER_E2E_TEST"
}
