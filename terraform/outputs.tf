output "instance_id" {
  value = aws_instance.webapp.id
}

output "public_ip" {
  description = "Use this as the EC2_HOST GitHub secret"
  value       = aws_instance.webapp.public_ip
}

output "app_url" {
  value = "http://${aws_instance.webapp.public_ip}:${var.app_port}"
}

output "ssh_command" {
  value = "ssh -i devops-demo.pem ubuntu@${aws_instance.webapp.public_ip}"
}
