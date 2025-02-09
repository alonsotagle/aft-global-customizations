locals {
  tfe_organization = jsondecode(data.aws_secretsmanager_secret_version.aft_secrets.secret_string)["tfe_organization"]
  tfe_project_id   = jsondecode(data.aws_secretsmanager_secret_version.aft_secrets.secret_string)["tfe_project_id"]
}

data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcp_terraform.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${local.tfe_organization}:project:${local.tfe_project_id}:workspace:*:run_phase:*"]
    }
  }
}

resource "aws_iam_role" "tfe_aws" {
  name               = "tfe-aws"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}
