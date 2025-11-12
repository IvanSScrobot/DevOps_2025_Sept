output "bucket_name" {
  description = "S3 bucket name for photo storage"
  value       = module.pasv_project.bucket_name
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.pasv_project.ec2_public_dns
}

output "app_url" {
  description = "URL to access the application"
  value       = module.pasv_project.app_url
}

output "key_name" {
  description = "Name of the EC2 key pair used"
  value       = module.pasv_project.key_name
}

output "private_key_pem" {
  description = "Private key for SSH access (only when auto-generated). Use: terraform output -raw private_key_pem > key.pem && chmod 400 key.pem"
  value       = module.pasv_project.private_key_pem
  sensitive   = true
}
