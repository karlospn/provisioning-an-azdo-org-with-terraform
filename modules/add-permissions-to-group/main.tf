terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

# Get project info
data "azuredevops_project" "project" {
  name = var.project_name
}

# Add project permissions to group
resource "azuredevops_project_permissions" "project-perm" {
  project_id  = data.azuredevops_project.project.id
  principal   = var.group_id
  permissions = var.project_permissions
}

# Add repository permissions to group
resource "azuredevops_git_permissions" "project-git-repository-perm" {
  project_id  = data.azuredevops_project.project.id
  principal   = var.group_id
  repository_id = var.repository_id
  permissions = var.git_permissions
}

#Add pipelines permissions to group
#Build a powershell script with the following steps:
#  - Get an access token using pat and basic auth
#  - Get all groups from Azure DevOps
#  - Find group by name
#  - Get descriptor
#  - Decode descriptor
#  - Add permissions using security api. Needs the decoded group descriptor and the permissions bitmask
# And run it like this:
# resource "null_resource" "pipeline permissions" {
#   provisioner "local-exec" {
#     command = "PowerShell -file ./set-pipelines-permissions.ps1 -pat ${var.personal_access_token}"   
#   }
# }