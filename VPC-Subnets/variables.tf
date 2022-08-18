variable "vpc-cidr"{
 default = "192.168.0.0/16"
 type = string
}

variable "region"{
 default = "us-west-1"
}

variable "subnet-1-cidr"{
 type = string
}
variable "subnet-2-cidr"{
 type = string
 default = "192.168.4.0/24"
}
