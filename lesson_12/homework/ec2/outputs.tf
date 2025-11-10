# output "instance_ids" {
#   description = "Launched EC2 instance IDs"
#   value       = [for i in aws_instance.my_test_t3_micro : i.id]
# }

# output "public_ips" {
#   description = "Public IP addresses of the EC2 instances"
#   value       = [for i in aws_instance.my_test_t3_micro : i.public_ip]
# }
