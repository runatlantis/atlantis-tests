terraform {
  required_version = ">= 1.4.0"
}

resource "terraform_data" "mixed_plan_mutation" {
  input = "ATLANTIS_E2E_MIXED_PLAN_MUTATION"
}

output "atlantis_e2e_mixed_apply_success" {
  value = "ATLANTIS_E2E_MIXED_BUILTIN_APPLY_MUST_NOT_RUN"
}
