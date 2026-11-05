variable "project_name" {
  description = "Project name used to name EKS resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS cluster and worker nodes"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN used by EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN used by EKS managed worker nodes"
  type        = string
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint"
  type        = list(string)
}

variable "vpc_cni_role_arn" {
  description = "IAM role ARN used by VPC CNI through EKS Pod Identity"
  type        = string
}

variable "ebs_csi_role_arn" {
  description = "ARN of the IAM role used by the EBS CSI controller"
  type        = string
}


variable "metrics_server_version" {
  description = "Metrics Server EKS add-on version"
  type        = string
}
