resource "null_resource" "tf_detection" {
  triggers = {
    marker = "atlantis-e2e-tf-detection"
  }
}

output "tf_detection_marker" {
  value = "detected-via-dot-tf"
}
