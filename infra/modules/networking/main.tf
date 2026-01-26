resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "${var.project_name}-vpc" }
}

# 2. Explicitly request the IPv6 Block
resource "aws_vpc_ipv6_cidr_block_association" "this" {
  vpc_id                       = aws_vpc.this.id
  assign_generated_ipv6_cidr_block = true
}

resource "aws_subnet" "public" {
  count                           = length(var.public_subnets)
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.public_subnets[count.index]
  # Assign a /64 IPv6 CIDR to each subnet
  ipv6_cidr_block = cidrsubnet(aws_vpc_ipv6_cidr_block_association.this.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true
  availability_zone               = var.availability_zones[count.index]
  map_public_ip_on_launch         = true

  tags = { Name = "${var.project_name}-public-${count.index}" }
}

# Update Route Table for IPv6
resource "aws_route" "public_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  ipv6_cidr_block = cidrsubnet(aws_vpc_ipv6_cidr_block_association.this.ipv6_cidr_block, 8, count.index + 2)
  assign_ipv6_address_on_creation = true
  availability_zone = var.availability_zones[count.index]
  tags = { Name = "${var.project_name}-private-${var.availability_zones[count.index]}" }
}

# --- Gateways ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project_name}-igw" }
}
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = { Name = "${var.project_name}-nat" }
}

# --- Routing ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project_name}-public-rt" }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project_name}-private-rt" }
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}