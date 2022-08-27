#...vpc variables...

variable "vpc-cidr" {}
variable "public-subnet-cidr" {
  type = list
}

variable "private-subnet-cidr" {
  type = list
}

variable "public_sn_count" {}

variable "private_sn_count" {}

variable "max_subnets" {}