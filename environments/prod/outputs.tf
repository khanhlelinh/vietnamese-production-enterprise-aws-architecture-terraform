output "transit_gateway_id" {
  value = module.network.transit_gateway_id
}

output "core_vpc_id" {
  value = module.network.core_vpc_id
}

output "sales_vpc_id" {
  value = module.network.sales_vpc_id
}

output "iot_vpc_id" {
  value = module.network.iot_vpc_id
}
