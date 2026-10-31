output "db_endpoint" {
  description = "PostgreSQL database hostname"
  value       = module.rds.db_endpoint
}
output "db_secret_arn" {
  description = "ARN of RDS-managed PostgreSQL credentials"
  value       = module.rds.db_secret_arn
}
output "ecr_repository_url" {
  description = "ECR repository URL for the Flask application"
  value       = module.ecr.repository_url
}
