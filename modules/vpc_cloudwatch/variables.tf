variable "name" {
  type = string 
  description = "Prefix name for resources"
}

variable "vpc_id" {
  
  description = "VPC ID for enabling flow logs"
  type        = string
}


variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "retention_in_days" {
  description = "Retention period for logs"
  type        = number
  default     = 7
}

variable "traffic_type" {
  description = "Type of traffic to capture: ACCEPT, REJECT, or ALL"
  type        = string
  default     = "ALL"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
