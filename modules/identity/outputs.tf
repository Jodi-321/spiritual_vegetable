output "uami_id" {
    description = "ID of the user-assigned managed identity"
    value = azurerm_user_assigned_identity.vm_identity.id
}

output "uami_client_id" {
    description = "Client ID of the managed identity - used to assign to VMs"
    value = azurerm_user_assigned_identity.vm_identity.client_id
}

/*
output "key_vault_id" {
    description = "ID of the key vault"
    value = azurerm_key_vault.main.id
}

output "key_vault_uri" {
    description = "URI of the key vault"
    value = azurerm_key_vault.main.vault_uri
}
*/

output "web_identity_id" {
    description = "Web VM user-assigned managed identity ID"
    value = azurerm_user_assigned_identity.web_identity.id
}

output "api_identity_id" {
    description = "API VM user-assigned managed identity ID"
    value = azurerm_user_assigned_identity.api_identity.id
}

output "vm_identity_id" {
    description = "VM user-assigned managed identity ID"
    value = azurerm_user_assigned_identity.vm_identity.id
}

output "appgw_identity_id" {
    description = "appgw user-assigned identity id"
    value = azurerm_user_assigned_identity.appgw_identity.id
}

output "appgw_identity_principal_id" {
    description = "Principal ID of the Application gateway managed identity"
    value = azurerm_user_assigned_identity.appgw_identity.principal_id
}