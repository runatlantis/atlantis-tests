locals {
  long_string = join("", [for i in range(1000) : "abcdefghijklmnopqrstuvwxyz0123456789-${i}-"])
}

resource "terraform_data" "long_line_output" {
  input = local.long_string
}

output "long_line_marker" {
  value = "long-line-output-test"
}
