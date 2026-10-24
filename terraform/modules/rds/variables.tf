variable "vpc_id" {
  description = "VPC ID where RDS resources will be created"
  type        = string
}


variable "db_subnet_ids" {
  description = "Database subnet IDs received from the VPC module"
  type        = map(string)
}

variable "project_name" {
  type = string

}
variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "eks_source_security_group_id" {
  description = "Security group ID allowed to access RDS PostgreSQL"
  type        = string

}