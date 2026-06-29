terraform {
  required_version = ">= 1.5.0"
}

resource "terraform_data" "on_apply_lock_preservation" {
  input = "on-apply-lock-preservation"
}

output "on_apply_lock_preservation_marker" {
  value = terraform_data.on_apply_lock_preservation.output
}
