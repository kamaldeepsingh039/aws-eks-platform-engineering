variable "eks_public_access_cidrs" {
  description = "Public IP CIDR blocks allowed to access the EKS API"
  type        = list(string)
}
