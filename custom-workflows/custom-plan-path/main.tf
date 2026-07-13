terraform {
  required_version = ">= 1.4.0"
}

resource "terraform_data" "custom_plan_path" {
  input = "ATLANTIS_E2E_CUSTOM_PLAN_PATH"
}

output "atlantis_e2e_custom_plan_path_marker" {
  value = terraform_data.custom_plan_path.output
}
