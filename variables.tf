variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the instance."
}

variable "instance_type" {
  type        = string
  description = "The type of instance to launch."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to use for resources."
}

variable "allowed_ports" {
  type        = set(number)
  description = "A list of allowed ports for inbound traffic."
}

variable "allowed_egress_ports" {
  type        = set(number)
  description = "A list of allowed egress ports for inbound traffic."
}
