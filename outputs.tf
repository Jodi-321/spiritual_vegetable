output "resource_group_name" {
    description = "name of resource group"
    value = azurerm_resource_group.main.name
}

output "vnet_id" {
    description = "ID of the created virtual network"
    value = module.networking.vnet_id
}

output "subnet_ids" {
    description = "map of subnet names to their IDs"
    value = module.networking.subnet_ids
}

output "network_security_group_ids" {
    description = "Map of NSG names to IDs"
    value = module.networking.network_security_group_ids
}

output "asg_ids" {
    description = "Map of application security group names to IDs"
    value = module.networking.asg_ids
}

output "application_gateway_ip" {
  description = "Public IP of the Application Gateway"
  value       = module.security.application_gateway_ip
}
