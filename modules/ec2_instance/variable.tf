variable "subnet_ids" {
  description = "List of private subnet IDs to launch instances into"
  type        = map(string)
}



variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}


variable "ssh_key_name" {
  description = "Name of SSH key pair for EC2"
  type        = string
}



variable "private_sg_id" {

  description = "security group ID"
  type        = list(string)
}

variable "user_data" {
  description = "User data script to run at instance launch"
  type        = string
  default     = null
}

variable "name" {
  description = "name of instances"
  type        = string

}