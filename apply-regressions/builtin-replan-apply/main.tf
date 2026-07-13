terraform {
  required_version = ">= 1.4.0"
}

variable "e2e_generation" {
  description = "Identifies the plan generation exercised by the E2E lifecycle."
  type        = string
  default     = "fixture-baseline"
}

resource "terraform_data" "builtin_replan_apply" {
  input = var.e2e_generation
}

output "atlantis_e2e_builtin_replan_generation" {
  value = "ATLANTIS_E2E_BUILTIN_REPLAN_${terraform_data.builtin_replan_apply.output}"
}
