resource "terraform_data" "heredoc_output" {
  input = <<-EOT
    This is a multiline heredoc string
    used to test plan output rendering.
    Line 3 with special chars: "quotes" & <brackets>
    Line 4 with trailing spaces
    Line 5 final line
  EOT
}

output "heredoc_marker" {
  value = "heredoc-output-test"
}
