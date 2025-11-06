variable "region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name tag value"
  type        = string
  default     = "dev"
}

variable "number_of_instances" {
  description = "Number of EC2 instances to create"
  type        = number
}
