terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azuredevops"{
    org_service_url = var.org_service_url
    personal_access_token = var.personal_access_token
}

## Create team project for the commercial team
resource "azuredevops_project" "project-comm" {
  name       = "Commercial Team Project"
  description        = "Repository used by the Commercial IT Team"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
      "boards" = "disabled"
      "repositories" = "enabled"
      "pipelines" = "enabled"
      "artifacts" = "enabled"
  }
}

## Create team project for the sales team
resource "azuredevops_project" "project-sales" {
  name       = "Sales Team Project"
  description        = "Repository used by the Sales IT Team"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
      "boards" = "disabled"
      "repositories" = "enabled"
      "pipelines" = "enabled"
      "artifacts" = "enabled"
  }
}