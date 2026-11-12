# Latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Private Jenkins EC2 instance
resource "aws_instance" "jenkins" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t3.large"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  associate_public_ip_address = false

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins"
  }
}
