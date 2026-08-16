# ------------------------------------------------------------------------------
# Enterprise Network Module - VPCs, Subnets, Transit Gateway, Route53, ALB, API Gateway
# ------------------------------------------------------------------------------

# VPCs
resource "aws_vpc" "core_enterprise" {
  cidr_block           = var.vpc_cidr_core
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.environment}-vpc-core-enterprise" })
}

resource "aws_vpc" "sales_commerce" {
  cidr_block           = var.vpc_cidr_sales
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.environment}-vpc-sales-commerce" })
}

resource "aws_vpc" "farm_food_iot" {
  cidr_block           = var.vpc_cidr_iot
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.environment}-vpc-farm-food-iot" })
}

# Transit Gateway for inter-VPC and On-Premises connectivity
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Enterprise Transit Gateway connecting 3 domains and On-Prem"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = merge(var.tags, { Name = "${var.environment}-tgw" })
}

# TGW Attachments (Example for Core)
resource "aws_ec2_transit_gateway_vpc_attachment" "core_attachment" {
  subnet_ids         = aws_subnet.core_private_app[*].id
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.core_enterprise.id
  tags               = merge(var.tags, { Name = "${var.environment}-tgw-attach-core" })
}

# Site-to-Site VPN / Virtual Private Gateway (Connecting On-Premise Enterprise VN DC)
resource "aws_vpn_gateway" "vpg" {
  vpc_id = aws_vpc.core_enterprise.id
  tags   = merge(var.tags, { Name = "${var.environment}-vpg" })
}

# Example Subnets for Core Enterprise Domain
resource "aws_subnet" "core_private_app" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.core_enterprise.id
  cidr_block        = cidrsubnet(var.vpc_cidr_core, 4, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags              = merge(var.tags, { Name = "${var.environment}-subnet-core-app-private-${count.index + 1}" })
}

resource "aws_subnet" "core_private_db" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.core_enterprise.id
  cidr_block        = cidrsubnet(var.vpc_cidr_core, 4, count.index + length(var.availability_zones))
  availability_zone = element(var.availability_zones, count.index)
  tags              = merge(var.tags, { Name = "${var.environment}-subnet-core-db-private-${count.index + 1}" })
}

# Route 53 Public/Private Hosted Zones
resource "aws_route53_zone" "private" {
  name = "internal.enterprisevietnam.com"
  vpc {
    vpc_id = aws_vpc.core_enterprise.id
  }
}

# Application Load Balancer (Edge & Ingress Layer)
resource "aws_lb" "external" {
  name               = "${var.environment}-ext-alb"
  internal           = false
  load_balancer_type = "application"
  # subnets = [...]
  tags               = var.tags
}
