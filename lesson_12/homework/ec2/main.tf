terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "MyApplication_backend"
    ManagedBy   = "Terraform"
  }

  ports = [22, 80, 443]

  ami = "ami-0bdd88bd06d16ba03" # Amazon Linux 2023
}


resource "aws_instance" "my_test_t3_micro" {
  count = var.number_of_instances

  ami                    = local.ami
  instance_type          = "t3.micro" # Free tier
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data              = file("${path.module}/user_data.sh")
  tags = merge(
    local.common_tags,
    {
      Name = "HelloWorld Server-$(count.index)"
    }
  )

  depends_on = [aws_security_group.web-sg]
}

resource "aws_security_group" "web-sg" {
  name        = "web-sg-${var.environment}"
  description = "Allow inbound traffic for web server"

  dynamic "ingress" {
    for_each = local.ports
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
