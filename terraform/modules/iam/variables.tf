variable "project_name" {
  description = "Name of the project used for IAM resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment such as dev, staging, prod"
  type        = string
}
