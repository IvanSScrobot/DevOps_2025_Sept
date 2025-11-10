terraform {
  backend "s3" {
    bucket         = "pasv-course-iskrobot-tf-state"
    key            = "main/demo_terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_version = ">= 1.8"
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source = "./ec2"

  environment         = var.env
  number_of_instances = var.ni
}

variable "env" {
  description = "Environment name tag value"
  type        = string
}

variable "ni" {
  description = "Number of istances to create"
  type        = number
}
