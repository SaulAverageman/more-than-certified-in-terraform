#...vpc/main...
data "aws_availability_zones" "az_available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input = data.aws_availability_zones.az_available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "vpc-res" {
  cidr_block  = var.vpc-cidr
  enable_dns_hostnames = true
  tags={
    Name = "dark-vpc"
  }
}

resource "aws_subnet" "public-subnet-res"{
    vpc_id = aws_vpc.vpc-res.id
    count = var.public_sn_count
    cidr_block = var.public-subnet-cidr[count.index]
    availability_zone = random_shuffle.az.result[count.index]
    map_public_ip_on_launch = true
    tags = {
      "Name" = join("-",["public-subnet",count.index+1])
    }
}

resource "aws_subnet" "private-subnet-res"{
    vpc_id = aws_vpc.vpc-res.id
    count = var.private_sn_count
    cidr_block = var.private-subnet-cidr[count.index]
    availability_zone = random_shuffle.az.result[count.index]
        tags = {
      "Name" = join("-",["private-subnet",count.index+1])
    }
}