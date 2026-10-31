data "aws_iam_policy_document" "eso_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "eso" {
  name = "aws-eks-platform-engineering-dev-eso-role"

  assume_role_policy = data.aws_iam_policy_document.eso_assume_role.json
}


data "aws_iam_policy_document" "eso_secrets_access" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      module.rds.db_secret_arn
    ]
  }
}


resource "aws_iam_role_policy" "eso_secrets_access" {
  name = "eso-rds-secrets-read"
  role = aws_iam_role.eso.id

  policy = data.aws_iam_policy_document.eso_secrets_access.json
}


resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = module.eks_cluster.cluster_id
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.eso.arn
}