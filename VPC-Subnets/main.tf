provider "aws"{
 profile = "vpc-creater"
 region = var.region
}

resource "aws_vpc"  "main-vpc"{
 cidr_block = var.vpc-cidr
 tags= {
  Name = "main-vpc"
 }

}

resource "aws_subnet" "subnet-1"{
 vpc_id = aws_vpc.main-vpc.id
 cidr_block = var.subnet-1-cidr
 tags = {
  Name = "subnet-1"
 }
}

resource "aws_subnet" "subnet-2"{
 vpc_id = aws_vpc.main-vpc.id
 cidr_block = var.subnet-2-cidr
 tags = {
  Name = "subnet-1"
 }
}

resource "aws_key_pair" "ec2-private-key"{
 key_name = ""
 public_key = ""
}

resource "aws_instance" "ec2-1" {
 subnet_id = aws_subnet.subnet-1.id
 ami = "ami-090fa75af13c156b4"
 key_name = aws_key_pair.ec2-private-key.key_name
 instance_type = "t2.micro"
 tags = {
  Name = "ec2-1"
 }
}
