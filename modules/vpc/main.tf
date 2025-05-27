
# --- VPC ---
resource "aws_vpc" "main_vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.name}-vpc"
    },
    var.tags
  )

}

#--- Internet Gateway ---
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# --- Public Subnets & Route Tables ---

resource "aws_subnet" "main_vpc_public_subnet" {

  vpc_id                  = aws_vpc.main_vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-public_subnet-${count.index}"
  })

}

resource "aws_route_table" "public_subnet_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "public_subnet_table"
  }
  
}

resource "aws_route" "main_vpc_public_default_route" {
  route_table_id         = aws_route_table.public_subnet_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id
}

resource "aws_route_table_association" "main_vpc_public_assoc" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.main_vpc_public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_table.id
}



# --- Private Subnets & NAT Gateway ---
resource "aws_subnet" "vpc_private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  count             = length(var.private_subnets)
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, {
    Name = "${var.name}-private_subnet-${count.index}"
  })

}

# Allocate an Elastic IP for NAT

resource "aws_eip" "nat_ip" {
  count  = length(var.private_subnets)
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })

}


# Create NAT Gateways
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.main_vpc_public_subnet[count.index].id
  count         = length(var.private_subnets)
  depends_on    = [aws_internet_gateway.vpc_igw]
  tags          = merge(var.tags, { Name = "${var.name}-natgw-${count.index}" })

}

# Private route table

resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { Name = "${var.name}-private-rt-for-NAT-${count.index}" })
}

resource "aws_route" "private_Nat_rt" {
  count                  = length(aws_nat_gateway.nat_gw)
  route_table_id         = aws_route_table.private_rt[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
  destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route_table_association" "private_rt_assiociationme" {
  count          = length(aws_subnet.vpc_private_subnet)
  route_table_id = aws_route_table.private_rt[count.index].id
  subnet_id      = aws_subnet.vpc_private_subnet[count.index].id
}

resource "aws_route" "public_sub_to_tgw" {
  route_table_id = aws_route_table.public_subnet_table.id
  destination_cidr_block = var.sec_region_vpc_cidr
  transit_gateway_id = var.transit_gateway_id
  
}