terraform {
  backend "s3" {
    bucket         = "pasv-course-iskrobot-tf-state" # REPLACE WITH YOUR BUCKET NAME
    key            = "main/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
  required_version = ">= 1.8"
}

provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "MyApplication_backend"
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "test_t3_micro" {
  count = var.number_of_instances

  ami                    = "ami-0bdd88bd06d16ba03" # Amazon Linux 2023
  instance_type          = "t3.micro"              # Free tier
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo dnf update
    sudo dnf install -y httpd
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    sudo bash -c 'cat > /var/www/html/index.html' <<EOF_HTML
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      body {
        background-color: #A1B0FF;
        text-align: center;
      }
    </style>
    </head>
    <body>
      <h1>Hello, Team.</h1>
      <h1>Welcome to server 1!</h1>
    </body>
    </html>
    EOF_HTML
  EOF
  tags = merge(
    local.common_tags,
    {
      Name = "HelloWorld Server-$(count.index)"
    }
  )

  depends_on = [aws_security_group.web-sg]
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = [for instance in aws_instance.test_t3_micro : instance.public_ip]
}

output "instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = [for instance in aws_instance.test_t3_micro : instance.public_dns]
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
