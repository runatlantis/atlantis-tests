# Exercises the plan output scanner boundary fix from v0.44.1 #6544.
# Generates a single-line string >64 KiB (~88 KiB).
# Uses range(1000) (Terraform caps range() at 1024 elements) with ~90 bytes
# per element to exceed the 64 KiB threshold.
locals {
  long_string = join("", [for i in range(1000) : "abcdefghijklmnopqrstuvwxyz0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ-padding-extra-${i}-"])
}

resource "terraform_data" "long_line_output" {
  input = local.long_string
}

output "long_line_marker" {
  value = "long-line-output-test"
}
