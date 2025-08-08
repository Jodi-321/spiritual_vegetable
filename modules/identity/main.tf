/*
# Key Vault
resource "azurerm_key_vault" "main" {
    name = "${var.project_name}-${var.environment}-kv"
    location = var.location
    resource_group_name = var.resource_group_name
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "standard"
    purge_protection_enabled = true
    soft_delete_retention_days = 7

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        secret_permissions = [
            "Get", "List", "Set", "Delete"
        ]
    }

    tags = var.common_tags
}


# User-Assigned Managed Identity (UAMI)
resource "azurerm_user_assigned_identity" "vm_identity" {
    name = "${var.project_name}-${var.environment}-uami"
    location = var.location
    resource_group_name = var.resource_group_name

    tags = var.common_tags
}
*/

# Granting acces to Key Vault Secrets

resource "azurerm_key_vault_secret" "sample_secret" {
    name = "test-secret2"
    value = var.test_secret_value
    key_vault_id = var.key_vault_id

    tags = var.common_tags

}
