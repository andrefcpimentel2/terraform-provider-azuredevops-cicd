# terraform-provider-azuredevops-cicd

# Simple GitHub based CICD
This sample provisions the following infrastructure:
You need to configure the Variables to this project such as:

* Project name
* Pipeline external config (Currently Github only)
* Github_personalAccessToken for fetching the external pipeline config


# AzDO project
AzDO build definition that points to .azdo/azure-pipeline-nightly.yml
GitHub service connection that grants AzDO the ability to interact with GitHub via a PAT
Builds will be triggered based on the trigger block in the yaml pipeline specified.

# Known Limitations
This configuration does not allow you to trigger checks in GitHub. A PAT service connection is not sufficient for PR checks because it only allows AzDO to communicate with GitHub (and not the other way around). There is a backlog item to address this.
