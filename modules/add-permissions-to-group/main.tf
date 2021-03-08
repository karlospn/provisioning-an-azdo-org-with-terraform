terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

## Transform the pipelines permissions map<string> into json
locals {
  pipelines_json = jsonencode(var.pipelines_permissions)
}

## Get project info
data "azuredevops_project" "project" {
  name = var.project_name
}

## Add project permissions to group
resource "azuredevops_project_permissions" "project-perm" {
  project_id  = data.azuredevops_project.project.id
  principal   = var.group_id
  permissions = var.project_permissions
}

## Add pipelines permissions to group
## TODO: Build a powershell script with the following steps:
#  - Get an access token using pat and basic auth
#  - Get all groups from Azure DevOps
#  - Find group by name
#  - Get descriptor
#  - Decode descriptor
#  - Add permissions using security api. Needs the decoded group descriptor and the permissions bitmask
resource "null_resource" "pipelines-perm" {
  provisioner "local-exec" {
    command = "pwsh -file ${path.module}\\set-pipelines-permissions.ps1 -personal_access_token ${var.personal_access_token} -pipelines_permissions ${local.pipelines_json} -group_descriptor ${var.group_descriptor}  -project_id ${data.azuredevops_project.project.id}"
  }
}
