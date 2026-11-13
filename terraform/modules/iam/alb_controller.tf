# Trust policy for AWS Load Balancer Controller using EKS Pod Identity
data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# Dedicated IAM role for AWS Load Balancer Controller
resource "aws_iam_role" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-controller-role"
  }
}

# Controller permissions from the official AWS Load Balancer Controller policy
resource "aws_iam_policy" "alb_controller" {
  name   = "${var.project_name}-${var.environment}-alb-controller-policy"
  policy = file("${path.module}/alb_controller_policy.json")
}

# Attach permissions to the controller role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}