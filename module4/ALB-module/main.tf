#...ALB/maain...

resource "aws_lb" "alb-res" {
  name               = "dark-alb"
  subnets            = var.public-subnets
  security_groups    = var.public-sg
  load_balancer_type = "application"
  idle_timeout       = 250
}

resource "aws_lb_target_group" "alb-tg-res" {
  name     = "dark-alb-tg-${substr(uuid(), 0, 4)}"
  port     = var.tg-port
  protocol = var.tg-protocol
  vpc_id   = var.vpc-id
  health_check {
    healthy_threshold   = var.tg-healthy-threshold
    unhealthy_threshold = var.tg-unhealthy-threshold
    timeout             = var.tg-timeout
    interval            = var.tg-interval
  }
  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener-res" {
  load_balancer_arn = aws_lb.alb-res.arn
  port              = var.listener-port
  protocol          = var.listener-protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg-res.arn
  }
}