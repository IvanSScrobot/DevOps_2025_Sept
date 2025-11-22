########################
# Provider & Variables #
########################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Existing EC2 key pair name (so you can SSH in)
variable "key_name" {
  description = "Name of an existing AWS key pair to use for SSH"
  type        = string
  default     = "ansible2"
}
