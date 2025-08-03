output "vnet_id" {
    description = "ID of the created virtual network"
    value = azurerm_virtual_network.main.id
}

output "subnet_ids" {
    description = "Map of subnet names to their resource IDs"
    value = {
        public = azurerm_subnet.public.id
        private_app = azurerm_subnet.private_app.id
        private_data = azurerm_subnet.private_data.id
    }
}

output "network_security_group_ids" {
    description = "Map of NSG names to their resource IDs"
    value = {
        public_subnet = azurerm_network_security_group.public_subnet.id
        private_app_subnet = azurerm_network_security_group.private_app_subnet.id
        private_data_subnet = azurerm_network_security_group.private_data_subnet.id
    }
}

output "resource_group_name" {
    description = "name of the resource group for networking components"
    value = var.resource_group_name
}

output "asg_ids" {
    description = "Map of application secuirty group names to their IDs"
    value = {
        web_servers = azurerm_application_security_group.web_servers.id
        api_servers = azurerm_application_security_group.api_servers.id
        database_servers = azurerm_application_security_group.database_servers.id
    }
}

output "bastion_subnet_id" {
    description = "Subnet ID for Azure Bastion"
    value = azurerm_subnet.bastion.id
}