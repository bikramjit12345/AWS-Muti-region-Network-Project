variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)

}

variable "private_subnets" {
  type = list(string)

}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  type = string
}

variable "sec_region_vpc_cidr" {
  type = string

}
variable "transit_gateway_id" {
  type = string

}




