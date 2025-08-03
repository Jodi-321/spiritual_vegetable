provider "azurerm" {
    features {}
    skip_provider_registration = true
}

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

module "identity" {
    source = "./modules/identity"
    project_name = var.project_name
    environment = var.environment
    location = var.location
    resource_group_name = azurerm_resource_group.main.name
    common_tags = var.common_tags
    test_secret_value = var.test_secret_value
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