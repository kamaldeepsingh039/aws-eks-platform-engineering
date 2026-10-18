# Amazon EKS managed Kubernetes control plane
resource "aws_eks_cluster" "this" {
  name                          = "${var.project_name}-${var.environment}-eks"
  role_arn                      = var.cluster_role_arn
  version                       = var.kubernetes_version
  bootstrap_self_managed_addons = false

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.public_access_cidrs
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-eks"
  }
}




# EKS managed worker node group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-${var.environment}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_eks_addon.vpc_cni
  ]
  tags = {
    Name = "${var.project_name}-${var.environment}-nodes"
  }
}

# Install the EKS Pod Identity Agent
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = "v1.3.10-eksbuild.3"

  tags = {
    Name = "${var.project_name}-${var.environment}-pod-identity-agent"
  }
}



# Manage the Amazon VPC CNI networking add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "vpc-cni"
  addon_version = "v1.22.4-eksbuild.3"

  pod_identity_association {
    service_account = "aws-node"
    role_arn        = var.vpc_cni_role_arn
  }

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc-cni"
  }
}

# Manage the Kubernetes kube-proxy add-on

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "kube-proxy"
  addon_version = "v1.36.0-eksbuild.48"

  tags = {
    Name = "${var.project_name}-${var.environment}-kube-proxy"
  }
}

# Manage kubernetes DNS through the CoreDNS add-on

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "coredns"
  addon_version = "v1.14.7-eksbuild.11"

  depends_on = [aws_eks_node_group.this]

  tags = {
    Name = "${var.project_name}-${var.environment}-coredns"
  }
}
