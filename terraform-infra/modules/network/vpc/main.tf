# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Create Subnets
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az_name
  map_public_ip_on_launch = each.value.public_ip

  tags = merge(
    {
      Name = "${each.value.subnet_name}_${each.value.az_name}"
    },

    each.value.enable_eks_tags && each.value.public_ip ? {
      "kubernetes.io/role/elb" = "1"
    } : {},

    each.value.enable_eks_tags && !each.value.public_ip ? {
      "kubernetes.io/role/internal-elb" = "1"
    } : {}
  )
}

#create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

# Create elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}_nat_eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnets[keys(local.public_subnet)[0]].id

  tags = {
    Name = "${var.vpc_name}_nat_gw"
  }

  depends_on = [aws_internet_gateway.igw]
}



# Create Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}_public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.vpc_name}_private_route_table"
  }
}


# Associate Subnets with Route Tables
resource "aws_route_table_association" "public_subnet_association" {
  for_each = local.public_subnet

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each = local.private_subnet

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}
