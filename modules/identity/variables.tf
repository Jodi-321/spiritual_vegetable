variable "project_name" {
    description = "Project name in resources"
    type = string
}

variable "environment" {
    description = "Deployment envrionment"
    type = string
}

variable "location" {
    description = "Azure region for deployed resources"
    type = string
}

variable "resource_group_name" {
    description = "Nme of the resource group to use"
    type = string
}

variable "common_tags" {
    description = "Tags to apply to resources"
    type = map(string)
}

variable "test_secret_value" {
    description = "Initial vaule for teh test key vault secret"
    type = string
}