variable "caller" {
  type    = string
  default = "unknown"
}

output "shared_value" {
  value = "shared-module-output-for-${var.caller}"
}
