output "eks_cluster_role_arn" {
  description = "ARN of the IAM role used by the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "ARN of the IAM role used by EKS managed worker nodes"
  value       = aws_iam_role.eks_node.arn
}

# IAM role ARN used by the VPC CNI through EKS Pod Identity

output "vpc_cni_role_arn" {
  description = "ARN of the IAM role used by the VPC CNI add-on"
  value       = aws_iam_role.vpc_cni.arn
}
