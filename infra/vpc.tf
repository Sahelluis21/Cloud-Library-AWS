# Lista de AZs válidas para sua região
data "aws_availability_zones" "available" {}

# --------------------------
# VPC
# --------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# --------------------------
# Internet Gateway
# --------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# --------------------------
# PUBLIC SUBNETS (ALB)
# --------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Public Route to Internet
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

# --------------------------
# PRIVATE SUBNETS (ECS)
# --------------------------
resource "aws_subnet" "ecs_private" {
  count      = length(var.private_subnets_ecs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_ecs[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-ecs-${count.index}"
  }
}

# PRIVATE SUBNETS (RDS)
resource "aws_subnet" "rds_private" {
  count      = length(var.private_subnets_rds)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_rds[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-rds-${count.index}"
  }
}

# --------------------------
# NAT GATEWAY
# --------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat"
  }
}

# --------------------------
# PRIVATE ROUTE TABLE
# --------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate ECS private subnets with private RT
resource "aws_route_table_association" "ecs_private_association" {
  count          = length(aws_subnet.ecs_private)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.ecs_private[count.index].id
}

# Associate RDS private subnets with private RT
resource "aws_route_table_association" "rds_private_association" {
  count          = length(aws_subnet.rds_private)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.rds_private[count.index].id
}
