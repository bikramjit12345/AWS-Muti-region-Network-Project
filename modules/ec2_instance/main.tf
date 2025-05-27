#  Data source: Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#  Launch EC2 instances: one per subnet * instance_count_per_subnet
resource "aws_instance" "ec2_instance" {
  for_each = var.subnet_ids

  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = each.value
  vpc_security_group_ids = var.private_sg_id
  user_data              = var.user_data
  tags = {
    Name = "${var.name}-${each.key}"
  }
}