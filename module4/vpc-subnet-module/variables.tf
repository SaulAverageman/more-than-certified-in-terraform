#...vpc variables...

variable "vpc-cidr" {}
variable "public-subnet-cidr" {
  type = list
}

variable "private-subnet-cidr" {
  type = list
}