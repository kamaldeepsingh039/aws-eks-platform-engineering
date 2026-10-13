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
}
