
# Identify the AWS account and region
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# ECR permissions for the Jenkins pipeline
data "aws_iam_policy_document" "jenkins_ecr" {

  # Authenticate to Amazon ECR
  statement {
    sid       = "ECRAuthentication"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # Access only our Flask application repository
  statement {
    sid    = "ECRImagePublishing"
    effect = "Allow"

    actions = [
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "arn:aws:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/eks-flask-app"
    ]
  }
}

# Attach ECR permissions to the existing Jenkins IAM role
resource "aws_iam_role_policy" "jenkins_ecr" {
  name   = "${var.project_name}-${var.environment}-jenkins-ecr"
  role   = aws_iam_role.jenkins.id
  policy = data.aws_iam_policy_document.jenkins_ecr.json
}
