variable "project_name" {
    type = string
}

variable "group_id" {
    type = string
}

variable project_permissions {
    type = map(string)
}

variable pipelines_permissions {
    type = map(string)
}

variable personal_access_token {
    type = string
}

variable group_descriptor {
    type = string
}