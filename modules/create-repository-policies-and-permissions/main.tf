terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}


## Get project info
data "azuredevops_project" "project" {
  name = var.project_name
}

## Get shared repository
data "azuredevops_git_repository" "shared-repository" {
  project_id = data.azuredevops_project.project.id
  name       = "shared"
}


## Create Git Repository
resource "azuredevops_git_repository" "repository" {
  project_id = data.azuredevops_project.project.id
  name       =  var.repository_name
  initialization {
    init_type = "Clean"
  }
}

## Add permissions to git repository
resource "azuredevops_git_permissions" "project-git-repository-perm" {
  project_id  = data.azuredevops_project.project.id
  principal   = var.group_id
  repository_id = azuredevops_git_repository.repository.id 
  permissions = var.git_permissions
}


## Start Branch permission block
resource "azuredevops_branch_policy_min_reviewers" "policy-min-reviewers" {
  project_id = data.azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count     = 2
    submitter_can_vote = false
    last_pusher_cannot_approve = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes = true

    scope {
      repository_id  = azuredevops_git_repository.repository.id               
      repository_ref = azuredevops_git_repository.repository.default_branch
      match_type     = "Exact"
    }
  }
}

resource "azuredevops_branch_policy_comment_resolution" "policy-comment-resolution" {
  project_id = data.azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {

     scope {
      repository_id  = azuredevops_git_repository.repository.id               
      repository_ref = azuredevops_git_repository.repository.default_branch
      match_type     = "Exact"
    }
  }
}

resource "azuredevops_build_definition" "pr-build-validation" {
  project_id  = data.azuredevops_project.project.id
  name        = "pr-validation-pipeline"
  path        = join("", ["\\", var.repository_name])
  
  repository {
    repo_type = "TfsGit"
    repo_id   = data.azuredevops_git_repository.shared-repository.id
    yml_path  = "pipelines/pr-validation-pipeline.yml"
  }
}

resource "azuredevops_branch_policy_build_validation" "policy-build-validation" {
  project_id = data.azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    display_name        = "${var.repository_name} pr validation"
    build_definition_id = azuredevops_build_definition.pr-build-validation.id
    valid_duration      = 720

    scope {
      repository_id  = azuredevops_git_repository.repository.id               
      repository_ref = azuredevops_git_repository.repository.default_branch
      match_type     = "Exact"
    }
  }
}

## End Branch permission block