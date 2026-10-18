output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.this.id

}
output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability Zone"

  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }

}
output "private_subnet_ids" {
  description = "Private subnet IDs keyed by availability zone"

  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }

}
output "nat_gateway_id" {
  description = "ID of NAT Gateway"
  value       = aws_nat_gateway.this.id

}