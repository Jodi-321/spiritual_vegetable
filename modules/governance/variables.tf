variable "resource_group_id" {
    description = "Resource group ID for the policy assigment"
    type = string
}

variable "display_name" {
    description = "Display name for the policy assignment"
    type = string
}

variable "description" {
    description = "Description of the policy assignment"
    type = string
}

variable "common_tags" {
    description = "Tags applied to resources"
    type = map(string)
}