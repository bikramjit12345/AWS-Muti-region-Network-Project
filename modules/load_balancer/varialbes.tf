variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)

}

variable "name" {

  type = string

}

variable "vpc_id" {
  type = string
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "Path for health check"
}

variable "health_check_interval" {
  type        = number
  default     = 30
  description = "Interval (in seconds) between health checks"
}

variable "healthy_threshold" {
  type        = number
  default     = 2
  description = "Number of consecutive successes for target to be considered healthy"
}

variable "unhealthy_threshold" {
  type        = number
  default     = 2
  description = "Number of consecutive failures before target is considered unhealthy"
}

variable "health_check_matcher" {
  type        = string
  default     = "200-399"
  description = "HTTP codes to indicate a healthy target"
}

variable "target_ids" {
  type = list(string)
  description = "List of EC2 instance IDs to attach to the target group"
}
