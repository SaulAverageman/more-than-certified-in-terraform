#...ALB/outputs...

output "target-group-arn" {
  value = aws_lb_target_group.alb-tg-res.arn
}