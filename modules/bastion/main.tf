# Bastion to reach private VMs
resource "azurerm_public_ip" "bastion" {
    name = "${var.project_name}-${var.environment}-pip-bastion"
    location = var.location
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"

    tags = var.common_tags
}

resource "azurerm_bastion_host" "main" {
    name = "${var.project_name}-${var.environment}-bastion"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "bastion-ipconfig"
        subnet_id = var.bastion_subnet_id
        public_ip_address_id = azurerm_public_ip.bastion.id
    }

    tags = var.common_tags
}