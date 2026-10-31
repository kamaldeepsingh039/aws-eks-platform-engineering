output "db_endpoint" {
  description = "RDS PostgreSQL connection endpoint"
  value       = aws_db_instance.postgres.address
}
output "db_secret_arn" {
  description = "ARN of the RDS-managed master credentials secret"
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
}