resource "aws_db_subnet_group" "postgres" {
  name       = "${var.project_name}-${var.environment}-postgres-subnets"
  subnet_ids = values(var.db_subnet_ids)

}
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "postgres_from_eks" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = var.eks_source_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_db_instance" "postgres" {
  identifier                  = "${var.project_name}-${var.environment}-postgres"
  engine                      = "postgres"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  multi_az                    = true
  username                    = "postgresadmin"
  manage_master_user_password = true
  publicly_accessible         = false
  backup_retention_period     = 7
  storage_encrypted           = true
  deletion_protection         = false
  skip_final_snapshot         = true


  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds.id]

}
