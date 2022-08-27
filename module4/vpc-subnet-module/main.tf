#...vpc/main...

resource "aws_vpc" "vpc-res" {
  cidr_block  = var.vpc-cidr
  enable_dns_hostnames = true
  tags={
    Name = "dark-vpc"
  }
}

resource "aws_subnet" "public-subnet-res"{
    vpc_id = aws_vpc.vpc-res.id
    count = length(var.public-subnet-cidr)
    cidr_block = var.public-subnet-cidr[count.index]
    map_public_ip_on_launch = true
    tags = {
      "Name" = join("-",["public-subnet",count.index])
    }
}

resource "aws_subnet" "private-subnet-res"{
    vpc_id = aws_vpc.vpc-res.id
    count = length(var.private-subnet-cidr)
    cidr_block = var.private-subnet-cidr[count.index]
        tags = {
      "Name" = join("-",["priavte-subnet",count.index])
    }
}