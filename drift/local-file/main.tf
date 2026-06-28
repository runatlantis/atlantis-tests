resource "local_file" "drift_target" {
  content  = "initial-content-for-drift-detection"
  filename = "${path.module}/drift-target.txt"
}

output "drift_marker" {
  value = "drift-detection-scaffold"
}
