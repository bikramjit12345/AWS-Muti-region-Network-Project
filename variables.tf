variable "vpc_cidr_us" {

  type = string


}
variable "vpc_cidr_eu" {

  type = string

}

variable "vpc_us_pub_subnets" {
  type = list(string)

}



variable "vpc_eu_pub_subnets" {
  type = list(string)
}

variable "vpc_us_pvt_subnets" {
  type = list(string)

}

variable "vpc_eu_pvt_subnets" {
  type = list(string)

}

variable "vpc_us_fw_subnets" {
  type = list(string)
}

variable "vpc_eu_fw_subnets" {
  type = list(string)

}

variable "az_us" {

  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]

}


variable "az_eu" {

  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "key_name" {
  description = "Name of SSH key pair for EC2"
  type        = string
}


variable "key_name_eu" {
  description = "Name of SSH key pair for EC2 in eu-west"
  type        = string
}
