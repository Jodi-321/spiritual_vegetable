variable "project_name" {
    description = "project name for resource naming"
    type = string
    default = "zero-trust-mvp"
}

variable "environment" {
    description = "Deployment environment"
    type = string
    default = "mvp"
}

variable "location" {
    description = "Azure region for deployment"
    type = string
    default = "East US"
}

variable "location_short" {
    description = "Short string for location"
    type = string
    default = "eastus"
}

variable "vnet_address_space" {
    description = "Address space for the virtual network"
    type = list(string)
    default = ["10.0.0.0/16"]
}

variable "common_tags" {
    description = "common tags for all resources"
    type = map(string)
    default = {
        Project = "Zero-Trust-MVP"
        Environemnt = "MVP"
        Owner = "DevSecOps-Team"
        CreatedBy = "Terraform"
    }
}

variable "admin_ssh_public_key" {
    description = "SSH key for test linux VM"
    type = string
}

variable "test_secret_value" {}

locals {
    admin_ssh_public_key = file("${path.module}/${var.admin_ssh_public_key}")
}

variable "vm_size" {
    description = "size of vm for resources"
    type = string
}

variable "admin_username" {
    description = "admin usernmae set for vms"
    type = string
}

variable "name_prefix" {
    description = "prefix for application gw"
    type = string
}

variable "retention_in_days" {
    description = "assigned rention period for logs"
    type = number
}
