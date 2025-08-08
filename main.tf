provider "azurerm" {
    features {}
    #skip_provider_registration = true
}

# Data source to get current client configuration
data "azurerm_client_config" "current" {}

# Resource Group Root
resource "azurerm_resource_group" "main" {
    name = "${var.project_name}-${var.environment}-rg"
    location = var.location

    tags = var.common_tags
}

module "networking" {
    source = "./modules/networking"
    project_name = var.project_name
    environment = var.environment
    location = var.location
    location_short = var.location_short
    vnet_address_space = var.vnet_address_space
    resource_group_name = azurerm_resource_group.main.name
    common_tags = var.common_tags
}

module "security" {
    source = "./modules/security"
    resource_group_name = azurerm_resource_group.main.name
    location = var.location
    location_short = var.location_short
    name_prefix = var.name_prefix
    subnet_id = module.networking.subnet_ids.public
    web_vm_private_ip = module.compute.web_vm_private_ip
    api_vm_private_ip = module.compute.api_vm_private_ip
    common_tags = var.common_tags
    environment = var.environment
    project_name = var.project_name
    appgw_identity_id = module.identity.appgw_identity_id
    appgw_identity_principal_id = module.identity.appgw_identity_principal_id
}

module "identity" {
    source = "./modules/identity"
    project_name = var.project_name
    environment = var.environment
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    common_tags = var.common_tags
    test_secret_value = var.test_secret_value
    key_vault_id = module.security.key_vault_id
}

module "compute" {
    source = "./modules/compute"
    project_name = var.project_name
    environment = var.environment
    location = var.location
    resource_group_name = module.networking.resource_group_name
    subnet_ids = module.networking.subnet_ids
    asg_ids = module.networking.asg_ids
    uami_id = module.identity.uami_id
    admin_ssh_public_key = local.admin_ssh_public_key
    common_tags = var.common_tags
    vm_size = var.vm_size
    admin_username = var.admin_username
    web_identity_id = module.identity.web_identity_id
    api_identity_id = module.identity.api_identity_id
}

module "bastion" {
    source = "./modules/bastion"
    project_name = var.project_name
    environment = var.environment
    location = var.location
    resource_group_name = module.networking.resource_group_name
    bastion_subnet_id = module.networking.bastion_subnet_id
    common_tags = var.common_tags
}

module "monitoring" {
    source = "./modules/monitoring"
    name = "${var.project_name}-${var.environment}-law-${var.location_short}"
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    retention_in_days = var.retention_in_days
    common_tags = var.common_tags
}


######## Application Gateway Diagnostic Settings ########
resource "azurerm_monitor_diagnostic_setting" "appgw" {
    name = "appgw-diagnostics"
    target_resource_id = module.security.application_gateway_id
    log_analytics_workspace_id = module.monitoring.workspace_id

    enabled_log {
        category = "ApplicationGatewayAccessLog"
    }

    enabled_log {
        category = "ApplicationGatewayFirewallLog"
    }

    enabled_log {
        category = "ApplicationGatewayPerformanceLog"
    }

    metric {
        category = "AllMetrics"
        enabled = true
    }
}

module "governance" {
    source = "./modules/governance"
    resource_group_id = azurerm_resource_group.main.id
    display_name = "ENFORCE HTTPS ONLY"
    description = "Ensure all web apps use HTTPS endpoints"
    common_tags = var.common_tags
}