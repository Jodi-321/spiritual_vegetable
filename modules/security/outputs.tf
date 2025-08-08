output "application_gateway_ip" {
    description = "Public IP of teh Application Gateway"
    value = azurerm_public_ip.appgw.ip_address
}

output "app_gateway_name" {
    description = "Name of applciation gateway"
    value = azurerm_application_gateway.main.name
}

output "application_gateway_id" {
    description = "ID of application gateway"
    value = azurerm_application_gateway.main.id
}

output "key_vault_id" {
    description = "ID of the key vault"
    value = azurerm_key_vault.main.id
}

output "key_vault_uri" {
    description = "URI of the key vault"
    value = azurerm_key_vault.main.vault_uri
}


output "appgw_certificate_secret_id" {
    description = "Secret ID of the TLS certificate for use in Application Gateway"
    value = azurerm_key_vault_certificate.appgw_cert.secret_id
}
