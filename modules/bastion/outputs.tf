output "bastion_public_ip" {
    description = "Public IP of the Bastion host"
    value = azurerm_public_ip.bastion.ip_address
}

output "bastion_host_name" {
    description = "name of teh Azure Bastion host"
    value = azurerm_bastion_host.main.name
}