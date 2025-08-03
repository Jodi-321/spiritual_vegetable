variable "project_name" {
    description = "Project identifier for resources"
    type = string
}

variable "environment" {
    description = "Deployment environment"
    type = string
}

variable "location" {
    description = "Aure deployment region"
    type = string
}

variable "location_short" {
    description = "location short hand"
    type = string
}

variable "vnet_address_space" {
    description = "CIDR address space for virtual network"
    type = list(string)
    default = ["10.0.0.0/16"]
}

variable "resource_group_name" {
    description = "Name of the resource group for deployed resources"
    type = string
}

variable "common_tags" {
    description = "Common tags for all resources"
    type = map(string)
}