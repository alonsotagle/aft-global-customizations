data "aws_ssm_parameter" "aft_account_ref" {
  name = "/aft/account-request/custom-fields/aft-account-ref"
}

data "aws_ssm_parameter" "github_repo" {
  name = "/aft/account-request/custom-fields/github-repo"
}

data "aws_ssm_parameter" "tfe_organization" {
  name = "/aft/account-request/custom-fields/tfe-organization"
}

data "aws_ssm_parameter" "tfe_project_id" {
  name = "/aft/account-request/custom-fields/tfe-project-id"
}

data "aws_ssm_parameter" "tfe_token" {
  name = "/aft/account-request/custom-fields/tfe-token"
}

data "aws_ssm_parameter" "tfe_github_app_id" {
  name = "/aft/account-request/custom-fields/tfe-github-app-id"
}
