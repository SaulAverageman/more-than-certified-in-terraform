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
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

#VPC Module
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

#RDS Module
module "rds" {
  source = "./rds-module"

  db_storage        = 10
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  db_name           = var.dbname
  db_user           = var.dbuser
  db_password       = var.dbpassword
  db_identifier     = "mysql-db"
  skip_db_snapshot  = true

  db_subnet_group_name   = module.vpc-subnets.rds-subnet-grp-name
  vpc_security_group_ids = module.vpc-subnets.private-sg
}

#ALB Module
module "alb" {
  source         = "./ALB-module"
  public-subnets = module.vpc-subnets.public-subnets
  public-sg      = module.vpc-subnets.public-sg

  tg-port                = 8000
  tg-protocol            = "HTTP"
  vpc-id                 = module.vpc-subnets.vpc-id
  tg-healthy-threshold   = 2
  tg-unhealthy-threshold = 2
  tg-timeout             = 3
  tg-interval            = 30

  listener-port     = 80
  listener-protocol = "HTTP"
}

#Compute module
module "compute" {
  source               = "./compute-module"
  instance-count       = var.instance-count
  instance-type        = "t3.micro"
  instance-subnet-ids  = module.vpc-subnets.public-subnets
  instance-sgs         = module.vpc-subnets.public-sg
  instance-volume-size = 10

  key-name = "dark-key"
  key-path = "./ssh/dark-key.pub"

  userdata-path = "./userdata.tpl"
  dbuser        = var.dbuser
  dbpassword    = var.dbpassword
  dbname        = var.dbname
  db-endpoint   = module.rds.rds-endpoint

  target-group-arn = module.alb.target-group-arn
  tg-port          = 8000
}