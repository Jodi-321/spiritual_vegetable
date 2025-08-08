output "vm_private_ip" {
    description = "Private IP of the test VM"
    value = azurerm_network_interface.main.private_ip_address
}

output "web_vm_private_ip" {
    description = "Private IP address of the Web VM"
    value = azurerm_network_interface.WEB_nic.ip_configuration[0].private_ip_address
}

output "api_vm_private_ip" {
    description = "Private IP address of the API VM"
    value = azurerm_network_interface.API_nic.ip_configuration[0].private_ip_address
}
