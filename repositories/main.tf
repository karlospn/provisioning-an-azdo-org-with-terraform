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

provider "azuread" {
    client_id = var.aad_client_id
    client_secret = var.aad_client_secret
    tenant_id     = var.aad_tenant_id
}

locals {
  comm_prj_name = "Commercial Team Project"
  sales_prj_name = "Sales Team Project"
  comm_group = "it-commercial-devs"
  sales_group = "it-sales-devs"
}

## Get commercial group info
data "azuredevops_project" "comm-group" {
  name = local.comm_group
}

## Get sales group info
data "azuredevops_project" "sales-group" {
  name = local.sales_group
}


## Create repository for commercial team apps
## Create repository for commercial team api
module "create-repository-and-policies-for-commercial-team-api" {
    source      = "../modules/create-repository-policies-and-permissions"
    project_name = local.comm_prj_name
    repository_name = "comm-api"
    group_id = data.azuredevops_project.comm-group.id
    git_permissions = {
        GenericRead = "Allow"
        CreateBranch = "Allow"
        GenericContribute = "Allow"
        PullRequestContribute = "Allow"
    }
}

## Create repository for commercial team ui
module "create-repository-and-policies-for-commercial-team-ui" {
    source      = "../modules/create-repository-policies-and-permissions"
    project_name = local.comm_prj_name
    repository_name = "comm-ui"
    group_id = data.azuredevops_project.comm-group.id
    git_permissions = {
        GenericRead = "Allow"
        CreateBranch = "Allow"
        GenericContribute = "Allow"
        PullRequestContribute = "Allow"
    }
}

## Create repository for sales team apps
## Create repository for sales team ui
module "create-repository-and-policies-for-sales-team-api" {
    source      = "../modules/create-repository-policies-and-permissions"
    project_name = local.comm_prj_name
    repository_name = "sales-api"
    group_id = data.azuredevops_project.sales-group.id
    git_permissions = {
        GenericRead = "Allow"
        CreateBranch = "Allow"
        GenericContribute = "Allow"
        PullRequestContribute = "Allow"
    }
}
