#...compute/output...

output "instances" {
  value     = aws_instance.node-res[*]
  sensitive = true
}

output "tg-ports" {
  value = aws_lb_target_group_attachment.lb-target-attachment[*].port
}