provider "aws" {
  region = "ca-central-1"

  default_tags {
    tags = {
      Project     = "aws-eks-platform-engineering"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
