############# Linux VM for testing ######################
## Network interface for Linux VM ###
resource "azurerm_network_interface" "main" {
    name = "${var.project_name}-${var.environment}-nic-linux"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "ipconfig1"
        subnet_id = var.subnet_ids["private_app"]
        private_ip_address_allocation = "Dynamic"
    }

    tags = var.common_tags
}

resource "azurerm_network_interface_application_security_group_association" "asg" {
    network_interface_id = azurerm_network_interface.main.id
    application_security_group_id = var.asg_ids["web_servers"]
}

## Linux VM ##
resource "azurerm_linux_virtual_machine" "main" {
    name = "${var.project_name}-${var.environment}-vm-linux"
    resource_group_name = var.resource_group_name
    location = var.location
    size = var.vm_size
    admin_username = var.admin_username
    disable_password_authentication = true
    network_interface_ids = [azurerm_network_interface.main.id]
    
    identity {
        type = "UserAssigned"

        ## Used to test key vault access
        identity_ids = [var.uami_id]
    }

    admin_ssh_key {
        username = var.admin_username
        public_key = var.admin_ssh_public_key
    }

    os_disk {
        name = "${var.project_name}-${var.environment}-osdisk-linux"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 32
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

    tags = var.common_tags
}





############# WEB VM ######################
## Network interface for WEB VM ###
resource "azurerm_network_interface" "WEB_nic" {
    name = "${var.project_name}-${var.environment}-nic-web"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "ipconfig1"
        subnet_id = var.subnet_ids["private_app"]
        private_ip_address_allocation = "Dynamic"
    }

    tags = var.common_tags
}

resource "azurerm_network_interface_application_security_group_association" "web_asg" {
    network_interface_id = azurerm_network_interface.WEB_nic.id
    application_security_group_id = var.asg_ids["web_servers"] #### check this
}



resource "azurerm_linux_virtual_machine" "web" {
    name = "${var.project_name}-${var.environment}-vm-web"
    location = var.location
    resource_group_name = var.resource_group_name
    size = var.vm_size
    admin_username = var.admin_username
    network_interface_ids = [
        azurerm_network_interface.WEB_nic.id
    ]

    os_disk {
        name = "${var.project_name}-${var.environment}-osdisk-web"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 32
    }

    admin_ssh_key {
        username = var.admin_username
        public_key = var.admin_ssh_public_key
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

    identity {
        type = "UserAssigned"
        identity_ids = [var.web_identity_id]
    }

    tags = var.common_tags
}



############# API VM ######################
## Network interface for API VM ###
resource "azurerm_network_interface" "API_nic" {
    name = "${var.project_name}-${var.environment}-nic-api"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name = "ipconfig1"
        subnet_id = var.subnet_ids["private_data"]
        private_ip_address_allocation = "Dynamic"
    }

    tags = var.common_tags
}

resource "azurerm_network_interface_application_security_group_association" "api_asg" {
    network_interface_id = azurerm_network_interface.main.id
    application_security_group_id = var.asg_ids["api_servers"]
}


resource "azurerm_linux_virtual_machine" "api" {
    name = "${var.project_name}-${var.environment}-vm-api"
    location = var.location
    resource_group_name = var.resource_group_name
    size = var.vm_size
    admin_username = var.admin_username
    network_interface_ids = [
        azurerm_network_interface.API_nic.id
    ]

    os_disk {
        name = "${var.project_name}-${var.environment}-osdisk-api"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 32
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

    admin_ssh_key {
        username = var.admin_username
        public_key = var.admin_ssh_public_key
    }

    identity {
        type = "UserAssigned"
        identity_ids = [var.api_identity_id]
    }

    tags = var.common_tags
}