output "db_endpoint" {
  description = "PostgreSQL database hostname"
  value       = module.rds.db_endpoint
}