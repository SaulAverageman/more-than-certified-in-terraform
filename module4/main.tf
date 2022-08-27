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

  public_sn_count  = var.public_sn_count
  private_sn_count = var.private_sn_count
  max_subnets      = max(var.public_sn_count, var.private_sn_count)

  public-subnet-cidr  = [for i in range(2, 255, 2) : cidrsubnet(var.vpc-cidr, 8, i)]
  private-subnet-cidr = [for i in range(1, 255, 2) : cidrsubnet(var.vpc-cidr, 8, i)]
}