output "id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_subnets_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnets_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "sg_id" {
  description = "ID of the security group"
  value       = aws_security_group.sg.id
}