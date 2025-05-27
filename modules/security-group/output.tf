output "security_group_id" {
  value       = aws_security_group.ec2_sg.id
  description = "ID of the created Security Group"
}