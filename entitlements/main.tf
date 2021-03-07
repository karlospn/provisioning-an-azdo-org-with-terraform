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

## Add entitlements to all users from the AAD it-sales-team
module "add-entitlement-to-group-users" {
    source      = "../modules/add-entitlement-to-group-users"
    aad_users_groups = ["it-sales-team"]
    license_type = "basic"
}

## Add entitlements to all users from the AAD it-commercial-team
module "add-entitlement-to-group-users" {
    source      = "../modules/add-entitlement-to-group-users"
    aad_users_groups = ["it-commercial-team"]
    license_type = "basic"
}

## Add entitlements to all users from the AAD it-managers-team
module "add-entitlement-to-group-users" {
    source      = "../modules/add-entitlement-to-group-users"
    aad_users_groups = ["it-managers-team"]
    license_type = "stakeholder"
}