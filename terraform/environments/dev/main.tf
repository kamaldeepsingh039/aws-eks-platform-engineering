module "eks_networking" {
  source = "../../modules/vpc"

  project_name = "aws-eks-platform-engineering"
  environment  = "dev"
  vpc_cidr     = "10.0.0.0/16"

  availability_zones = [
    "ca-central-1a",
    "ca-central-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  db_subnet_cidrs = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
}

# IAM role for the EKS control plane and managed worker nodes
module "eks_iam" {
  source = "../../modules/iam"

  project_name = "aws-eks-platform-engineering"
  environment  = "dev"
}

#EKS control plane and managed worker nodes

module "eks_cluster" {
  source = "../../modules/eks"

  project_name       = "aws-eks-platform-engineering"
  environment        = "dev"
  kubernetes_version = "1.36"

  private_subnet_ids = values(module.eks_networking.private_subnet_ids)

  cluster_role_arn    = module.eks_iam.eks_cluster_role_arn
  node_role_arn       = module.eks_iam.eks_node_role_arn
  public_access_cidrs = var.eks_public_access_cidrs
  vpc_cni_role_arn    = module.eks_iam.vpc_cni_role_arn

  depends_on = [module.eks_iam]

}

# RDS PostgreSQL infrastructure
module "rds" {
  source = "../../modules/rds"

  project_name = "aws-eks-platform-engineering"
  environment  = "dev"

  vpc_id                       = module.eks_networking.vpc_id
  db_subnet_ids                = module.eks_networking.db_subnet_ids
  eks_source_security_group_id = module.eks_cluster.cluster_security_group_id
}