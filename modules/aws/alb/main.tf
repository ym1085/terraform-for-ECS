# Application Load Balancer
resource "aws_lb" "core-api-alb-test" {
  name               = "core-api-alb-test"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.core_alb_meta_public_subnets # TODO: 변수로 받아야함
  security_groups    = [var.core_alb_meta_sg_id]        # TODO: 변수로 받아야함

  enable_deletion_protection = true

  tags = {
    "createdby"    = "ymkim1085@funin.camp"
    "env"          = "stage"
    "map-migrated" = "d-server-00pq62lmigxr9w"
    "service"      = "search-recommend"
    "servicetag"   = "search-e-d"
    "servicetype"  = "elb"
    "teamtag"      = "AG"
  }
}

# Application Load Balancer Listener
resource "aws_lb_listener" "core-api-alb-listener-test" {
  load_balancer_arn = aws_lb.core-api-alb-test.arn
  port              = var.alb_listener.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# Application Load Balancer Target Group List
resource "aws_lb_target_group" "core-api-tg-test" {
  for_each = { for idx, target_group in var.core_alb_meta_tg : target_group.name => target_group }

  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.type == "alb" ? "HTTP" : "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  # Target Group health checking
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    port                = "traffic-port"
    protocol            = each.value.type == "alb" ? "HTTP" : "TCP"
    timeout             = each.value.type == "alb" ? 10 : 10
    unhealthy_threshold = each.value.type == "alb" ? 3 : 3
  }

  tags = {
    "createdby"    = "ymkim1085@funin.camp"
    "env"          = "stage"
    "map-migrated" = "d-server-00pq62lmigxr9w"
    "service"      = "search-recommend"
    "servicetag"   = "search-e-d"
    "servicetype"  = "elb"
    "teamtag"      = "AG"
  }
}
