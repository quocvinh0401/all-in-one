output "id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_subnets_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}