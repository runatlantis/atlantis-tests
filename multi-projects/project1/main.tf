resource "null_resource" "e2e" {
  triggers = {
    run = timestamp()
  }
}
