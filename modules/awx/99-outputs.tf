//  Output some useful variables for quick SSH access etc.
output "awx1-public_dns" {
  value = "${aws_instance.awx1.public_dns}"
}