variable "project_name" {
    type = string
}

variable "group_id" {
    type = string
}

variable "repository_id" {
    type =string
}

variable project_permissions {
    type = map(string)
}

variable git_permissions {
    type = map(string)
}