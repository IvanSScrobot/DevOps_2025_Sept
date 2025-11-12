output "bucket_name" {
  value = aws_s3_bucket.photos.bucket
}

output "ec2_public_dns" {
  value = aws_instance.web.public_dns
}

output "app_url" {
  value = "http://${aws_instance.web.public_dns}:${local.web_port}"
}

output "key_name" {
  description = "Name of the EC2 key pair used"
  value       = local.ec2_key_name
}

output "private_key_pem" {
  description = "Private key for SSH access (only when auto-generated). Save this securely!"
  value       = var.key_name == "" ? tls_private_key.ec2_key[0].private_key_pem : null
  sensitive   = true
}
