# ==================== VPC Outputs ====================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

# ==================== Subnet Outputs ====================
output "subnet_ids" {
  description = "Map of all subnet IDs"
  value = {
    for k, s in aws_subnet.subnets : k => s.id
  }
}

output "private_subnet_ids" {
  description = "List of private subnet IDs (required for EKS)"
  value = [
    for k, s in aws_subnet.subnets : s.id
    if !s.map_public_ip_on_launch
  ]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs (required for EKS)"
  value = [
    for k, s in aws_subnet.subnets : s.id
    if s.map_public_ip_on_launch
  ]
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value = [
    for k, s in aws_subnet.subnets : s.cidr_block
    if !s.map_public_ip_on_launch
  ]
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value = [
    for k, s in aws_subnet.subnets : s.cidr_block
    if s.map_public_ip_on_launch
  ]
}

output "subnet_details" {
  description = "Detailed information about all subnets"
  value = {
    for k, s in aws_subnet.subnets : k => {
      id                = s.id
      cidr_block        = s.cidr_block
      availability_zone = s.availability_zone
      is_public         = s.map_public_ip_on_launch
    }
  }
}

# ==================== Internet Gateway Outputs ====================
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# ==================== NAT Gateway Outputs ====================
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_gateway_private_ip" {
  description = "The private IP address of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.private_ip
}

# ==================== Route Table Outputs ====================
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private_route_table.id
}

# ==================== Availability Zones ====================
output "availability_zones" {
  description = "List of availability zones used"
  value       = distinct([for s in aws_subnet.subnets : s.availability_zone])
}

output "private_subnets_by_az" {
  description = "Map of availability zones to private subnet IDs"
  value = {
    for k, s in aws_subnet.subnets : s.availability_zone => s.id...
    if !s.map_public_ip_on_launch
  }
}

output "public_subnets_by_az" {
  description = "Map of availability zones to public subnet IDs"
  value = {
    for k, s in aws_subnet.subnets : s.availability_zone => s.id...
    if s.map_public_ip_on_launch
  }
}

# ==================== Outputs for EKS Module ====================
output "eks_vpc_config" {
  description = "VPC configuration for EKS cluster (all required values)"
  value = {
    vpc_id = aws_vpc.vpc.id
    subnet_ids = concat(
      [for k, s in aws_subnet.subnets : s.id if s.map_public_ip_on_launch],
      [for k, s in aws_subnet.subnets : s.id if !s.map_public_ip_on_launch]
    )
    private_subnet_ids = [for k, s in aws_subnet.subnets : s.id if !s.map_public_ip_on_launch]
    public_subnet_ids  = [for k, s in aws_subnet.subnets : s.id if s.map_public_ip_on_launch]
  }
}

# ==================== Summary Output ====================
output "network_summary" {
  description = "Summary of network configuration"
  value = {
    vpc_id             = aws_vpc.vpc.id
    vpc_cidr           = aws_vpc.vpc.cidr_block
    availability_zones = distinct([for s in aws_subnet.subnets : s.availability_zone])
    public_subnets     = length([for s in aws_subnet.subnets : s if s.map_public_ip_on_launch])
    private_subnets    = length([for s in aws_subnet.subnets : s if !s.map_public_ip_on_launch])
    nat_gateways       = 1
  }
}
