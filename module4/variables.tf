#...root/varibales

variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "192.168.0.0/16"
}

/*
variable "public-subnet-cidr" {
  default = [for i in range(2,9,2):cidrsubnet(var.vpc-cidr,8,i)]
}

variable "private-subnet-cidr" {
  default = [for i in range(1,8,2):cidrsubnet(var.vpc-cidr,8,i)]
}
*/