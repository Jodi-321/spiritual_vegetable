# Virtual Network

resource "azurerm_virtual_network" "main" {
    name = "${var.project_name}-${var.environment}-${var.location_short}"
    location = var.location
    resource_group_name = var.resource_group_name
    address_space = var.vnet_address_space

    tags = var.common_tags
}

# Subnets - Three-Tier Architecture
resource "azurerm_subnet" "public" {
    name = "${var.project_name}-${var.environment}-subnet-public"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [local.subnet_cidrs.public]
}

resource "azurerm_subnet" "private_app" {
    name = "${var.project_name}-${var.environment}-subnet-private-app"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [local.subnet_cidrs.private_app]
}

resource "azurerm_subnet" "private_data" {
    name = "${var.project_name}-${var.environment}-subnet-private-data"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = [local.subnet_cidrs.private_data]
}

resource "azurerm_network_security_group" "public_subnet" {
    name = "${var.project_name}-${var.environment}-nsg-public"
    location = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "private_app_subnet" {
    name = "${var.project_name}-${var.environment}-nsg-private-app"
    location = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "private_data_subnet" {
    name = "${var.project_name}-${var.environment}-nsg-private-data"
    location = var.location
    resource_group_name = var.resource_group_name
}

# Subnet to NSG Association
resource "azurerm_subnet_network_security_group_association" "public" {
    subnet_id = azurerm_subnet.public.id 
    network_security_group_id = azurerm_network_security_group.public_subnet.id
}

resource "azurerm_subnet_network_security_group_association" "private_app" {
    subnet_id = azurerm_subnet.private_app.id
    network_security_group_id = azurerm_network_security_group.private_app_subnet.id
}

resource "azurerm_subnet_network_security_group_association" "private_data" {
    subnet_id = azurerm_subnet.private_data.id
    network_security_group_id = azurerm_network_security_group.private_data_subnet.id
}

#NSG Rules

#NSG Public Rule
resource "azurerm_network_security_rule" "public_allow_https" {
    name = "Allow-HTTPS-From-Internet"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.public_subnet.name
    description = "Allow HTTPS inbound from Internet to Application Gateway"
}

#Rule redirects to 443
resource "azurerm_network_security_rule" "public_allow_http" { 
    name = "Allow-Http-From-Internet"
    priority = 120
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.public_subnet.name
    description = "Allo HTTP inbound from Internet to App GW (Will Redirect to HTTPS)"
}

resource "azurerm_network_security_rule" "public_allow_appgw_management" {
    name = "Allow-AppGW-Management"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "65200-65535"
    source_address_prefix = "GatewayManager"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.public_subnet.name
    description = "Allow Azure App GW Management traffic"
}

resource "azurerm_network_security_rule" "public_allow_azure_lb" {
    name = "Allow-Azure-Loadbalancer"
    priority = 130
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "AzureLoadBalancer"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.public_subnet.name
    description = "Allow Azure Load Balancer probes"
}
resource "azurerm_network_security_rule" "public_deny_all" {
    name = "Deny-All-Inbound"
    priority = 4096
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.public_subnet.name
    description = "Default deny-all rule fro ZT"
}

#Private App NSG Rule
resource "azurerm_network_security_rule" "private_app_allow_from_web_asg" {
    name = "Allow-App-Tier-From-Web_ASG"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "8443"
    source_application_security_group_ids = [azurerm_application_security_group.web_servers.id]
    destination_application_security_group_ids = [azurerm_application_security_group.api_servers.id]
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.private_app_subnet.name
    description = "Allow Web ASG to communicate with API ASG onport 8443"
}

resource "azurerm_network_security_rule" "private_app_allow_ssh_from_bastion" {
    name = "Allow-SSH-Fromt-Bastion"
    priority = 150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "10.0.4.0/27" #Bastion subnet CIDR
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "22"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.private_app_subnet.name
    description = "Allow SSH from Bastion subnet to private app VMs"
}

resource "azurerm_network_security_rule" "private_app_deny_all" {
    name = "Deny-All-Inbound"
    priority = 4096
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.private_app_subnet.name
    description = "Default deny-all rule for App Subnet"
}

#Private Data NSG Rule
resource "azurerm_network_security_rule" "private_data_allow_from_api_asg" {
    name = "Allow-DB-Tier-From-API-ASG"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1433"
    resource_group_name = var.resource_group_name
    source_application_security_group_ids = [azurerm_application_security_group.api_servers.id]
    destination_application_security_group_ids = [azurerm_application_security_group.database_servers.id]
    network_security_group_name = azurerm_network_security_group.private_data_subnet.name
    description = "Allow API ASG to communicate with Database ASG on port 1433"
}

resource "azurerm_network_security_rule" "private_data_allow_ssh_from_bastion" {
    name = "Allow-SSH-From-Bastion"
    priority = 150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "10.0.4.0/27" #Bastion subnet CIDR
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "22"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.private_data_subnet.name
    description = "Allow SSH from Bastion subnet to private data VMs"
}

resource "azurerm_network_security_rule" "private_data_deny_all" {
    name = "Deny-All-Inbound"
    priority = 4096
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.private_data_subnet.name
    description = "Default deny-all rule for DB subnet"
}





#################### Application Security Groups ########################################
resource "azurerm_application_security_group" "web_servers" {
    name = "${var.project_name}-${var.environment}-asg-web"
    location = var.location
    resource_group_name = var.resource_group_name

    tags = var.common_tags
}

resource "azurerm_application_security_group" "api_servers" {
    name = "${var.project_name}-${var.environment}-asg-api"
    location = var.location
    resource_group_name = var.resource_group_name

    tags = var.common_tags
}

resource "azurerm_application_security_group" "database_servers" {
    name = "${var.project_name}-${var.environment}-asg-db"
    location = var.location
    resource_group_name = var.resource_group_name

    tags = var.common_tags
}

# Local Values
locals {
    subnet_cidrs = {
        public = "10.0.1.0/24"
        private_app = "10.0.2.0/24"
        private_data = "10.0.3.0/24"
    }
}


# Bastion network
resource "azurerm_subnet" "bastion" {
    name = "AzureBastionSubnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = ["10.0.4.0/27"]
}

/*
resource "azurerm_network_security_group" "bastion_subnet" {
    name = "${var.project_name}-${var.environment}-nsg-bastion"
    location = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
    subnet_id = azurerm_subnet.bastion.id
    network_security_group_id = azurerm_network_security_group.bastion_subnet.id
}

resource "azurerm_network_security_rule" "bastion_https" {
    name = "Allow-Bastion-HTTPS"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "GatewayManager"
    source_port_range = "*"
    destination_port_range = "443"
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.bastion_subnet.name
    description = "Allow HTTPS access for Azure Bastion"
}

*/
