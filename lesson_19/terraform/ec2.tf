
###################
# Ubuntu AMI Data #
###################

# Latest Ubuntu 22.04 LTS in us-east-1
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



###################
# EC2 Instances   #
###################

# Common user_data script to install Python on Ubuntu
locals {
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3
              EOF
}

# Web server
resource "aws_instance" "web" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = element(data.aws_subnets.default.ids, 0)

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = local.user_data

  tags = {
    Name = "web-server"
    Role = "web"
  }
}

# DB server
resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = element(data.aws_subnets.default.ids, 0)

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  user_data = local.user_data

  tags = {
    Name = "db-server"
    Role = "db"
  }
  
}

###################
# Useful Outputs  #
###################

output "web_public_ip" {
  value       = [for i in aws_instance.web : i.public_ip]
  description = "Public IP of the web server"
}

output "db_public_ip" {
  value       = aws_instance.db.public_ip
  description = "Public IP of the db server"
}
