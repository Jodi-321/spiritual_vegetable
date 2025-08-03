output "vm_private_ip" {
    description = "Private IP of the test VM"
    value = azurerm_network_interface.main.private_ip_address
}

