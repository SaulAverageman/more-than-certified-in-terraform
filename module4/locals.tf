locals {
  sgs = {
    public = {
      name        = "public-sg"
      description = "allows ssh and http to all"
      ingress = {
        ssh = {
          to       = 22
          from     = 22
          protocol = "tcp"
          cidrs    = [var.access_ip]
        }
        http = {
          to       = 80
          from     = 80
          protocol = "tcp"
          cidrs    = [var.access_ip]
        }

      }
    }
    private = {
      name        = "private-sg"
      description = "allows local access to rds"
      ingress = {
        rds = {
          to       = 3306
          from     = 3306
          protocol = "tcp"
          cidrs    = [var.vpc-cidr]
        }
      }
    }
  }
}