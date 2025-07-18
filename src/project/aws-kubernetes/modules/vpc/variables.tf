variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets in the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets in the VPC"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZ for the VPC subnets"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

