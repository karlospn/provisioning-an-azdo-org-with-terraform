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


locals {
  comm_prj_name = "Commercial Team Project"
  sales_prj_name = "Sales Team Project"
}


## Create AzDo group for the sales teams
module "create-group-and-add-users-for-sales-team" {
    source      = "../modules/create-group-and-add-users"
    project_name = local.sales_prj_name
    group_name = "it-sales-devs"
    group_description = "group for commercial developers"
    aad_users_groups = ["it-sales-team"]
}

## Add project permissions to the sales group
module "add-permissions-to-sales-group"{
    source      = "../modules/add-permissions-to-group"
    personal_access_token = var.personal_access_token
    project_name = local.comm_prj_name
    group_id = module.create-group-and-add-users-for-sales-team.group_id
    group_descriptor = module.create-group-and-add-users-for-sales-team.group_descriptor
    project_permissions = {
        GENERIC_READ        = "Allow"
        START_BUILD         = "Allow"
        VIEW_TEST_RESULTS   = "Allow"
    }
    pipelines_permissions = {

    }
}

## Create AzDo group for the commercial teams
module "create-group-and-add-users-for-comm-team" {
    source      = "../modules/create-group-and-add-users"
    project_name = local.comm_prj_name
    group_name = "it-commercial-devs"
    group_description = "group for commercial developers"
    aad_users_groups = ["it-commercial-team"]
}

## Add project permissions to the comm group
module "add-permissions-to-comm-group"{
    source      = "../modules/add-permissions-to-group"
    personal_access_token = var.personal_access_token
    project_name = local.comm_prj_name
    group_id = module.create-group-and-add-users-for-comm-team.group_id
    group_descriptor = module.create-group-and-add-users-for-sales-team.group_descriptor
    project_permissions = {
        GENERIC_READ        = "Allow"
        START_BUILD         = "Allow"
        VIEW_TEST_RESULTS   = "Allow"
    }
    pipelines_permissions = {

    }
}