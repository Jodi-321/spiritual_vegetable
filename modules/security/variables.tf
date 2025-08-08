variable "resource_group_name" {
    description = "Name of the resource group"
    type = string
}

variable "location" {
    description = "Azure region"
    type = string
}

variable "location_short" {
    description = "Shortened region code"
    type = string
}

variable "subnet_id" {
    description = "ID of the public subnet of Application Gateway"
    type = string
}

variable "web_vm_private_ip" {
    description = "Private IP of the Web VM"
    type = string
}

variable "api_vm_private_ip" {
    description = "Private IP of the API VM"
    type = string
}

variable "common_tags" {
    description = "Tags to apply to all resources"
    type = map(string)
}

variable "project_name" {
    description = "name of project"
    type = string
}

variable "environment" {
    description = "Deployment environment"
    type = string
}

variable "name_prefix" {
    description = "prefix for applciation GW"
    type = string
}

variable "appgw_identity_id" {
    description = "user assigned identity id for appgw"
    type = string
}

variable "appgw_identity_principal_id" {
    description = "Principal ID of the Application Gateway managed identity"
    type = string
}