provider "tfe" {
  token        = data.aws_ssm_parameter.tfe_token.value
  organization = data.aws_ssm_parameter.tfe_organization.value
}

resource "tfe_workspace" "aft_workspace" {
  name                  = data.aws_ssm_parameter.aft_account_ref.value
  description           = "This workspace is created automatically by AWS AFT account creation."
  auto_apply            = true
  file_triggers_enabled = false
  working_directory     = "terraform"
  tag_names             = ["managedby-aft"]
  project_id            = data.aws_ssm_parameter.tfe_project_id.value

  vcs_repo {
    branch                     = "main"
    identifier                 = data.aws_ssm_parameter.github_repo.value
    github_app_installation_id = data.aws_ssm_parameter.tfe_github_app_id.value
  }
}

resource "tfe_workspace_settings" "aft_workspace_settings" {
  workspace_id        = tfe_workspace.aft_workspace.id
  execution_mode      = "remote"
  global_remote_state = true
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  key          = "TFC_AWS_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  workspace_id = tfe_workspace.aft_workspace.id
}

resource "tfe_variable" "tfc_example_role_arn" {
  sensitive    = true
  key          = "TFC_AWS_RUN_ROLE_ARN"
  value        = aws_iam_role.tfe_aws.arn
  category     = "env"
  workspace_id = tfe_workspace.aft_workspace.id
}
