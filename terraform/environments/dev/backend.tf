terraform {
  backend "s3" {
    bucket       = "kamaldeepsingh-terraform-state-2026"
    key          = "eks-platform/dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true

  }
}