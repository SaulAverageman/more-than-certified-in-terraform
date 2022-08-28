#...ALB/variables...

variable "public-subnets" {
  type = list(any)
}
variable "public-sg" {
  type = list(any)
}

#target group vars
variable "tg-port" {}
variable "tg-protocol" {}
variable "vpc-id" {}
variable "tg-healthy-threshold" {}
variable "tg-unhealthy-threshold" {}
variable "tg-timeout" {}
variable "tg-interval" {}

#listener vars
variable "listener-port" {}
variable "listener-protocol" {}