#...root/main...
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "dark-place-v33"
    key    = ".terraform"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

module "vpc-subnets" {
  source   = "./vpc-subnet-module"
  vpc-cidr = var.vpc-cidr

  public-subnet-cidr = [for i in range(2,9,2): cidrsubnet(var.vpc-cidr,8,i)]
  private-subnet-cidr = [for i in range(1,8,2): cidrsubnet(var.vpc-cidr,8,i)]
}