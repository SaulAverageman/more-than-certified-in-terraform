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

variable "access_ip" {
  default = "0.0.0.0/0"
}

#database vars
variable "dbname" {}
variable "dbuser" { sensitive = true }
variable "dbpassword" { sensitive = true }

#ALB vars
