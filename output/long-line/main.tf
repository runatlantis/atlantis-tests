# Generates a single-line string >64 KiB (~84 KB) to exercise the plan output
# scanner boundary fix from v0.44.1 #6544.
locals {
  long_string = join("", [for i in range(2000) : "abcdefghijklmnopqrstuvwxyz0123456789-${i}-"])
}

resource "terraform_data" "long_line_output" {
  input = local.long_string
}

output "long_line_marker" {
  value = "long-line-output-test"
}
