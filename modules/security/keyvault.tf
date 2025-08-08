# Key Vault
resource "azurerm_key_vault" "main" {
    name = "${var.project_name}-${var.environment}-kv"
    location = var.location
    resource_group_name = var.resource_group_name
    tenant_id = data.azurerm_client_config.current.tenant_id
    sku_name = "standard"
    purge_protection_enabled = true
    soft_delete_retention_days = 7

    # Enable Azure services to bypass firewall
    network_acls {
      default_action = "Allow"
      bypass = "AzureServices"
    }

    # service principal access
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        secret_permissions = [
            "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
        ]

        key_permissions = [
            "Get", "Create", "List", "Delete", "Recover", "Backup", "Restore", "Purge", "Decrypt", "Encrypt", "Sign", "Verify", "WrapKey", "UnwrapKey"
        ]

        certificate_permissions = [
            "Get", "Create", "List", "Delete", "Import", "Update", "Recover", "Backup", "Restore", "Purge", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"
        ]
    }

    # Application Gateway managed identity access policy
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = var.appgw_identity_principal_id

        secret_permissions = [
            "Get"
        ]

        certificate_permissions = [
            "Get"
        ]
    }

    tags = var.common_tags
}