# Make sure to set the following environment variables:
#   AZDO_PERSONAL_ACCESS_TOKEN
#   AZDO_ORG_SERVICE_URL
#   AZDO_GITHUB_SERVICE_CONNECTION_PAT
provider "azuredevops" {
  version = ">= 0.0.1"
}

resource "azuredevops_project" "project" {
  project_name       = var.project_name
  visibility         = var.project_visibility
  version_control    = var.version_control
  work_item_template = var.work_item_template
}



resource "azuredevops_serviceendpoint_github" "github_serviceendpoint" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = var.service_endpoint_name
  auth_personal {
    personal_access_token = var.Github_personalAccessToken
  }
}

resource "azuredevops_build_definition" "nightly_build" {
  project_id      = azuredevops_project.project.id
  agent_pool_name = var.agent_pool_name
  name            = var.build_definition_name
  path            = var.build_definition_path

  repository {
    repo_type             = var.repo_type
    repo_id               = var.repo_id
    branch_name           = var.branch_name
    yml_path              = var.yml_path
    service_connection_id = azuredevops_serviceendpoint_github.github_serviceendpoint.id
  }
}


resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.project.id
  name       = var.repo_name
  # parent_id  = data.azuredevops_git_repositories.single_repo.id
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_branch_policy_build_validation" "repo_build_policy" {
  count      = var.enable_repo_build_policy ? 1 : 0
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Don't break the build!"
    build_definition_id = azuredevops_build_definition.nightly_build.id
    valid_duration      = 0

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }
  }
}

resource "azuredevops_branch_policy_min_reviewers" "repo_build_reviewers" {
  count      = var.enable_repo_build_reviewers ? 1 : 0
  project_id = azuredevops_project.project.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count     = var.policy_reviewer_count
    submitter_can_vote = false

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = azuredevops_git_repository.repo.default_branch
      match_type     = "Exact"
    }

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = "refs/heads/releases"
      match_type     = "Prefix"
    }
  }
}

output "project_name" {
  value = azuredevops_project.project.project_name
}
