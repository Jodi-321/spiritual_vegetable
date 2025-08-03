variable "project_name" {
    description = "Project name"
    type = string
}

variable "environment" {
    description = "Deployment environment"
    type = string
}

variable "location" {
    description = "Azure region"
    type = string
}

variable "resource_group_name" {
    description = "Resource group name"
    type = string
}

variable "common_tags" {
    description = "Tags for all resources"
    type = map(string)
}

variable "subnet_ids" {
    description = "ID of the subnet to attach the VM"
    type = map(string)

    validation {
        condition = alltrue([for i in ["private_app", "private_data"] : contains(keys(var.subnet_ids), i)])
        error_message = "subnet_ids must contain 'private_app' and 'private_data' keys"
    }
}

variable "asg_ids" {
    description = "ID of the application Security Group for the VM"
    type = map(string)

    validation {
        condition = alltrue([for j in ["web_servers","api_servers", "database_servers"] : contains(keys(var.asg_ids), j)])
        error_message = "asg_ids must contain 'web_servers', 'api_servers' and 'database_servers' keys"
    }
}

variable "uami_id" {
    description = "User-Assigned Managed Identity ID"
    type = string
}

variable "admin_ssh_public_key" {
    description = "SSH public key for Linux admin user"
    type = string
}
    
variable "web_identity_id" {
    description = "Web VM managed identity ID"
    type = string
}

variable "api_identity_id" {
    description = "API VM managed identity ID"
    type = string
}

variable "vm_size" {
    description = "size for vm resources"
    type = string
}

variable "admin_username" {
    description = "assigned username for VMs"
    type = string
}