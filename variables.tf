variable "project_name" {
description = "Name for AZ Devops Project"
default = ""
}

variable "project_visibility" {
description = ""
default = "private"
}

variable "version_control" {
description = ""
default = "Git"
}

variable "work_item_template" {
description = ""
default = "Agile"
}

variable "agent_pool_name" {
description = ""
default = "Hosted Ubuntu 1604"
}

variable "build_definition_name" {
description = ""
default = "IPO Build"
}

variable "build_definition_path" {
description = ""
default = "\\"
}

variable "service_endpoint_name" {
description = ""
default = "GitHub Service Connection"
}

variable "repo_type" {
description = ""
default = "GitHub"
}

variable "repo_id" {
description = ""
default = "microsoft/terraform-provider-azuredevops"
}

variable "branch_name" {
description = ""
default = "master"
}

variable "yml_path" {
description = ""
default = ".azdo/azure-pipeline-nightly.yml"
}

variable "Github_personalAccessToken" {
}


variable "policy_reviewer_count" {

  default = 2
}

variable "enable_repo_build_policy" {

  default = true
}

variable "enable_repo_build_reviewers" {

  default = true
}
