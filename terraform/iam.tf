locals {
  tfe_organization = data.aws_ssm_parameter.tfe_organization.value
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
      values   = ["organization:${local.tfe_organization}:project:aws-aft:workspace:${tfe_workspace.aft_workspace.id}:run_phase:*"]
    }
  }
}

resource "aws_iam_role" "tfe_aws" {
  name               = "tfe-aws"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}
