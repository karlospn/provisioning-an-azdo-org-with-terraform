terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    azuread = {
      source = "azuread"
      version = ">=1.4.0"
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


## Create AzDo group for the sales teams
module "add-users-for-sales-team-to-azdo-group" {
    source      = "../modules/add-aad-users-to-azdo-group"
    project_name =  "Commercial Team Project"
    azdo_group_name = "Contributors"
    aad_users_groups = ["it-commercial-team"]
}

## Create AzDo group for the commercial teams
module "add-users-for-comm-team-to-azdo-group" {
    source      = "../modules/add-aad-users-to-azdo-group"
    project_name = "Sales Team Project"
    azdo_group_name = "Contributors"
    aad_users_groups = ["it-sales-team"]
}