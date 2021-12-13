
provider "aws" {
  region  = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "s3_reader" {
  name        = "s3_reader"
  description = "s3_reader"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
         "Action": [
          "s3:*"
        ],
        "Resource": [
          "arn:aws:s3:::consumer-s3-example",
          "arn:aws:s3:::consumer-s3-example/*"
        ]
      }
    ]
  })
}

data "aws_iam_policy_document" "eks_pods" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:default:${var.eks_sa}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"]
      type        = "Federated"
    }
  }
}

# create a role that can be attached to pods.
resource "aws_iam_role" "eks_pods" {
  assume_role_policy = data.aws_iam_policy_document.eks_pods.json
  name               = "consumer-s3-example-eks-pods"

}

resource "aws_iam_role_policy_attachment" "aws_pods" {
  role       = aws_iam_role.eks_pods.name
  policy_arn = aws_iam_policy.s3_reader.arn
}