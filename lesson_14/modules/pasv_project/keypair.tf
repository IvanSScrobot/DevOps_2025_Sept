# Generate a private key if key_name is not provided
resource "tls_private_key" "ec2_key" {
  count = var.key_name == "" ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair from generated key if key_name is not provided
resource "aws_key_pair" "generated_key" {
  count = var.key_name == "" ? 1 : 0

  key_name   = "${var.environment}-${local.name_prefix}-generated-key"
  public_key = tls_private_key.ec2_key[0].public_key_openssh

  tags = {
    Name = "${var.environment}-${local.name_prefix}-generated-key"
  }
}

# Local to determine which key to use
locals {
  ec2_key_name = var.key_name != "" ? var.key_name : aws_key_pair.generated_key[0].key_name
}
