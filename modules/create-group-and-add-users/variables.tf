variable "project_name" {
    type = string
}

variable "group_name" {
    type = string
}

variable "group_description" {
    type = string
}

variable "aad_users_groups" {
    type = list(string)
    default = []
}
