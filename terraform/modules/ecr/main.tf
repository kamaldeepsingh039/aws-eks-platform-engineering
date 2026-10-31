resource "aws_ecr_repository" "flask_app" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}
