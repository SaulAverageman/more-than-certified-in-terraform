#...root/varibales

variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "192.168.0.0/16"
}

variable "public_sn_count" {
  default = 2
}
variable "private_sn_count" {
  default = 3
}