terraform {
  required_version = ">= 1.4.0"
}

variable "e2e_generation" {
  description = "Identifies the custom plan generation exercised by E2E."
  type        = string
  default     = "fixture-baseline"
}

resource "terraform_data" "custom_plan_replan" {
  input = var.e2e_generation
}

output "atlantis_e2e_custom_replan_generation" {
  value = "ATLANTIS_E2E_CUSTOM_REPLAN_${terraform_data.custom_plan_replan.output}"
}
