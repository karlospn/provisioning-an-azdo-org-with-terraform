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


## Add the commercial teams AAD group as contributor on the commercial team project
module "add-comm-group-to-azdo-sec-group" {
    source      = "../modules/add-aad-groups-to-azdo-team-project-sec-group"
    project_name =  "Commercial Team Project"
    azdo_group_name = "Contributors"
    aad_users_groups = ["it-commercial-team"]
}

## Add the sales teams AAD group as contributor on the sales team project
module "add-sales-group-to-azdo-sec-group" {
    source      = "../modules/add-aad-groups-to-azdo-team-project-sec-group"
    project_name = "Sales Team Project"
    azdo_group_name = "Contributors"
    aad_users_groups = ["it-sales-team"]
}


## Add the managers AAD group group as readers on the commercial team project
module "add-manager-group-to-comm-azdo-sec-group" {
    source      = "../modules/add-aad-groups-to-azdo-team-project-sec-group"
    project_name =  "Commercial Team Project"
    azdo_group_name = "Readers"
    aad_users_groups = ["it-managers-team"]
}


## Add the managers AAD group as readers on the sales team project
module "add-manager-group-to-sales-azdo-sec-group" {
    source      = "../modules/add-aad-groups-to-azdo-team-project-sec-group"
    project_name = "Sales Team Project"
    azdo_group_name = "Readers"
    aad_users_groups = ["it-managers-team"]
}