#...ALB/outputs...

output "target-group-arn" {
  value = aws_lb_target_group.alb-tg-res.arn
}

output "lb-dns" {
  value = aws_lb.alb-res.dns_name
}