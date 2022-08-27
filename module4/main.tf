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
