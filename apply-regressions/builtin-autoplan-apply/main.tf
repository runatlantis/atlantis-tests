terraform {
  required_version = ">= 1.4.0"
}

resource "terraform_data" "builtin_autoplan_apply" {
  input = "ATLANTIS_E2E_BUILTIN_AUTOPLAN_APPLY_OK"
}

output "atlantis_e2e_builtin_autoplan_apply_marker" {
  value = terraform_data.builtin_autoplan_apply.output
}
