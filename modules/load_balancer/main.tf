# Create Application load balancer 
resource "aws_lb" "app_lb" {
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
  tags               = merge({ Name = "${var.name}" })

}

# create Instance Target Group

resource "aws_lb_target_group" "app_lb_tg" {

  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = var.health_check_matcher
  }
  tags = merge({ Name = "${var.name}-tg" })
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn

  }

}

resource "aws_lb_target_group_attachment" "ec2" {
count            = length(var.target_ids)
target_group_arn = aws_lb_target_group.app_lb_tg.arn
target_id        = var.target_ids[count.index]
port             = 80
}


