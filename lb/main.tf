resource "aws_lb" "public" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.sg]
  subnets            = var.subnet

  tags = {
    Environment = "production"
  }
}  
resource "aws_lb_target_group" "public" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}
resource "aws_lb_target_group_attachment" "public" {
  count=length(var.subnet)  
  target_group_arn = aws_lb_target_group.public.arn
  target_id        = var.instance[count.index]
  port             = 80
}
resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}  