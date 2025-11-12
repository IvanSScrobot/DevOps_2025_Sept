variable "region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.1.1.0/24"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH to EC2 (e.g. your home IP /32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing EC2 key pair name. If empty, a new key pair will be generated."
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for staging environment"
  type        = string
}

variable "pillow_layer_zip" {
  description = "Path to Pillow layer zip (optional). If empty, Lambda will run without layer."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "staging"
}
