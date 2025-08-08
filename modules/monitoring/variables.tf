variable "name" {
    description = "name of teh Log Analytics workspace"
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

variable "retention_in_days" {
    description = "Log retention period"
    type = number
    default = 30
}

variable "common_tags" {
    description = "Tags for the workspace"
    type = map(string)
}