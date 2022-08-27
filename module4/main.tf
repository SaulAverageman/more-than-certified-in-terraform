#...root/main...
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
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

  security-grps = local.sgs

  db_subnet_gp_required = true

}

module "rds" {
  source = "./rds-module"

  db_storage        = 10
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  dbname            = var.dbname
  dbuser            = var.dbuser
  dbpassword        = var.dbpassword
  db_identifier     = "mysql-db"
  skip_db_snapshot  = true

  db_subnet_group_name   = module.vpc-subnets.rds-subnet-grp-name
  vpc_security_group_ids = module.vpc-subnets.private-sg
}