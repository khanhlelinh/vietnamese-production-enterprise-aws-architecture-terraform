output "core_vpc_id" {
  value = aws_vpc.core_enterprise.id
}

output "sales_vpc_id" {
  value = aws_vpc.sales_commerce.id
}

output "iot_vpc_id" {
  value = aws_vpc.farm_food_iot.id
}

output "core_private_app_subnet_ids" {
  value = aws_subnet.core_private_app[*].id
}

output "core_private_db_subnet_ids" {
  value = aws_subnet.core_private_db[*].id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id
}
