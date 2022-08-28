#...vpc/main...
data "aws_availability_zones" "az_available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.az_available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "vpc-res" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "dark-vpc"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public-subnet-res" {
  vpc_id                  = aws_vpc.vpc-res.id
  count                   = var.public_sn_count
  cidr_block              = var.public-subnet-cidr[count.index]
  availability_zone       = random_shuffle.az.result[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = join("-", ["public-subnet", count.index + 1])
  }
}

resource "aws_subnet" "private-subnet-res" {
  vpc_id            = aws_vpc.vpc-res.id
  count             = var.private_sn_count
  cidr_block        = var.private-subnet-cidr[count.index]
  availability_zone = random_shuffle.az.result[count.index]
  tags = {
    "Name" = join("-", ["private-subnet", count.index + 1])
  }
}

#internet connection resources
resource "aws_internet_gateway" "igw-res" {
  vpc_id = aws_vpc.vpc-res.id
  tags = {
    Name = "dark-gateway"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-res.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "internet-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-res.id
}

resource "aws_route_table_association" "public-rt-assn" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public-subnet-res[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

#private connection resources
resource "aws_default_route_table" "default-private-rt" {
  default_route_table_id = aws_vpc.vpc-res.default_route_table_id
  tags = {
    Name = "default-private-rt"
  }
}

#security groups
resource "aws_security_group" "sg-res" {
  for_each    = var.security-grps
  vpc_id      = aws_vpc.vpc-res.id
  name        = each.value.name
  description = each.value.description

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      to_port     = ingress.value.to
      from_port   = ingress.value.from
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidrs
    }
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#RDS resources
resource "aws_db_subnet_group" "rds-subnet-grp" {
  count      = var.db_subnet_gp_required ? 1 : 0
  name       = "rds-subnet-grp"
  subnet_ids = aws_subnet.private-subnet-res.*.id
  tags = {
    "Name" = "rds-subnet-group"
  }
}
