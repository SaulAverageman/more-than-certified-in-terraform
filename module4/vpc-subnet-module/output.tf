#...vpc outputs...

output "vpc" {
  value = aws_vpc.vpc-res.id
}

output "rds-subnet-grp-name" {
  value = aws_db_subnet_group.rds-subnet-grp[0].name
}

output "private-sg" {
  value = aws_security_group.sg-res["private"].*.id
}