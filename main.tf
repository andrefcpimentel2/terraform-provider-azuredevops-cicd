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
    personalAccessToken = var.Github_personalAccessToken
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
