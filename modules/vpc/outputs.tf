output "vpc_id" {

  value = aws_vpc.main_vpc.id

}

output "public_subnets_id" {

  value = aws_subnet.main_vpc_public_subnet[*].id

}

output "private_subnets_id" {

  value = aws_subnet.vpc_private_subnet[*].id

}

output "vpc_cidr" {
  value = aws_vpc.main_vpc.cidr_block
}

output "public_subnet_map" {
  description = "Map of AZ to public subnet ID"
  value = {
    for idx, subnet in aws_subnet.main_vpc_public_subnet :
    var.availability_zones[idx] => subnet.id
  }
}
