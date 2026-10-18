# Trust policy: Allow Amazon EKS to assume the cluster role

data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# IAM role used by the EKS control plane

resource "aws_iam_role" "eks_cluster" {
  name               = "${var.project_name}-${var.environment}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster-role"
  }
}

#Attach AWS-managed permissions to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# Trust policy: Allow EC2 instances to assume the worker node role

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role use by EKS managed worker nodes

resource "aws_iam_role" "eks_node" {
  name               = "${var.project_name}-${var.environment}-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-node-role"
  }
}

# Allow worker nodes to intract with the EKS cluster

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

# Allow worker nodes to pull container image from ECR

resource "aws_iam_role_policy_attachment" "eks_node_ecr_policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"

}

# Trust policy for the VPC CNI Pod Identity role
data "aws_iam_policy_document" "vpc_cni_assume_role" {
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
# Dedicated IAM role for Amazon VPC CNI
resource "aws_iam_role" "vpc_cni" {
  name = "${var.project_name}-${var.environment}-vpc-cni-role"

  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc-cni-role"
  }
}

# Allow VPC CNI to manage ENIs and Pod IP addresses
resource "aws_iam_role_policy_attachment" "vpc_cni_policy" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}