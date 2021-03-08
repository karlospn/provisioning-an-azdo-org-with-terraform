variable "project_name" {
    type = string
}

variable "azdo_group_name" {
    type = string
}

variable "aad_users_groups" {
    type = list(string)
    default = []
}

