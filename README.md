# Provisioning an Azure DevOps organization using Terraform

This repository contains an example about how you could provision an Azure DevOps Team organization using the official terraform provider   

## Prerequisites
There are some prerequisites that we need to fulfill in order to ran this example.
- Having an existing AzDo organization.
- Having your AzDo organization connected to an AAD directory.
  - That's needed because we're not going to create new users, we're going to use AAD groups and enrolls the users on those groups into our AzDo organization.


## Terraform folder structure

The repository is divided by:
- **/project** folder : Provision the team project for the different teams.
- **/entitlements** folder: Enrolls the AAD users from a given AAD group into the AzDO organization giving them an AzDo license.
  - It uses a module **add-entitlement-to-group-users** found in the **/modules** folder.
- **/groups** folder: Reads the given groups from AAD and adds them into the given security group of a given team project.
  - It uses a module **add-aad-users-to-azdo-group** found in the **/modules** folder.
- **/repository** folder: Creates the repositories for the given apps and also creates the master branch policies
  - It uses a module **create-repository-and-branch-policies** found in the **/modules** folder.


## Terraform modules parameters:


