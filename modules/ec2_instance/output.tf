output "instance_name" {
  value = var.name
}

output "instances_ids" {
  value = [for instance in aws_instance.ec2_instance : instance.id]
}
