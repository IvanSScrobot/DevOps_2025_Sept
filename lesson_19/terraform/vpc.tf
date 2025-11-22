#######################
# Security Groups     #
#######################

# Security group for the web server: SSH + HTTP (8080) from anywhere
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and 8080 from anywhere"
  vpc_id      = data.aws_vpc.default.id

  # SSH from anywhere
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Web port 8080 from anywhere
  ingress {
    description = "Web 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Security group for the DB server: SSH only from anywhere
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = data.aws_vpc.default.id

  # SSH from anywhere (you can restrict this further if you like)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

###########################
# Default VPC / Subnet(s) #
###########################

# Use the default VPC in us-east-1
data "aws_vpc" "default" {
  default = true
}

# Get default subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
