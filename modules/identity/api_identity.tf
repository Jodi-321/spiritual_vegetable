resource "azurerm_user_assigned_identity" "api_identity" {
   name = "${var.project_name}-${var.environment}-api-identity"
   location = var.location
   resource_group_name = var.resource_group_name

   tags = var.common_tags
}

resource "azurerm_key_vault_access_policy" "api_identity_policy" {
    key_vault_id = var.key_vault_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.api_identity.principal_id

    secret_permissions = ["Get","List"]
}