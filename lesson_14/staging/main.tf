module "pasv_project" {
  source = "../modules/pasv_project"

  region             = var.region
  project_tag        = "pasv-staging"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  instance_type      = var.instance_type
  key_name           = var.key_name
  bucket_name        = var.bucket_name
  environment        = var.environment
}
