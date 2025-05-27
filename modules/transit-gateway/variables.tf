

variable "name" {

  description = "name of the tranist gateway"
  type        = string

}
variable "subnet_ids" {
  description = "list of subnet ids of the attached VPC"
  type        = list(string)

}

variable "vpc_id" {

  description = "attached VPC with transit gateway"
  type        = string


}
variable "destination_vpc" {
  type = string
}
variable "peering_attachment_id" {
  type = string
}

