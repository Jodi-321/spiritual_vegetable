variable "project_name" {
    description = "name of the project"
    type = string
}

variable "environment" {
    description = "Deployment environment"
    type = string
}

variable "location" {
    description = "Azure region to deploy to"
    type = string
}

variable "resource_group_name" {
    description = "Resource group for Bastion and IP"
    type = string
}

variable "bastion_subnet_id" {
    description = "ID of the public subnet where Bastion will be deployed"
    type = string
}

variable "common_tags" {
    description = "Common tags for all resources"
    type = map(string)
}
