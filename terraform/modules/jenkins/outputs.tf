output "jenkins_instance_id" {
  description = "EC2 instance id of the Jenkins server"
  value       = aws_instance.jenkins.id
}

output "jenkins_private_ip" {
  description = "Private IP address of Jenkins server"
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_security_group_id" {
  description = "Security Group Id of the Jenkins server"
  value       = aws_security_group.jenkins.id
}
