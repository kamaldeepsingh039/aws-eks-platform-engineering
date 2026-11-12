# Dedicated security group for Jenkins EC2

resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-${var.environment}-jenkins-sg"
  description = "Security group for private Jenkins EC2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-sg"
  }
}


# Allow Jenkins to initiate outbound connections
resource "aws_vpc_security_group_egress_rule" "jenkins_outbound" {
  security_group_id = aws_security_group.jenkins.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow outbound traffic for Jenkins"

}
