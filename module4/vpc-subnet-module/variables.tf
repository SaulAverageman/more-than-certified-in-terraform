#...vpc variables...

variable "vpc-cidr" {}
variable "public-subnet-cidr" {
  type = list(any)
}

variable "private-subnet-cidr" {
  type = list(any)
}

variable "public_sn_count" {}

variable "private_sn_count" {}

variable "max_subnets" {}

variable "security-grps" {}

variable "db_subnet_gp_required" {
  type = bool
}