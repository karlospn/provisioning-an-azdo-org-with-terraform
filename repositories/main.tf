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
}

## Create repository for commercial team apps
## Create repository for commercial team api
module "create-repository-and-policies-for-commercial-team-api" {
    source      = "../modules/create-repository-and-branch-policies"
    project_name = local.comm_prj_name
    repository_name = "comm-api"
}

## Create repository for commercial team ui
module "create-repository-and-policies-for-commercial-team-ui" {
    source      = "../modules/create-repository-and-branch-policies"
    project_name = local.comm_prj_name
    repository_name = "comm-ui"
}

## Create repository for sales team apps
## Create repository for sales team ui
module "create-repository-and-policies-for-sales-team-api" {
    source      = "../modules/create-repository-and-branch-policies"
    project_name = local.sales_prj_name
    repository_name = "sales-api"
}
