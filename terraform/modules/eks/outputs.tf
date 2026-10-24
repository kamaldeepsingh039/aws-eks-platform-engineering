output "cluster_id" {
  description = "Name of EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint for the kubernetes API server"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_id" {
  description = "Identifier of the EKS managed node group"
  value       = aws_eks_node_group.this.id
}

output "cluster_security_group_id" {
  description = "Security group ID automatically created by Amazon EKS"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}