# ALB 생성
resource "aws_lb" "alb" {
  for_each = var.alb

  name               = "${each.value.alb_name}-${each.value.env}" # ELB 이름
  internal           = each.value.alb_internal                    # ELB internal or external 여부
  load_balancer_type = each.value.alb_load_balancer_type          # ELB 타입
  subnets            = var.public_subnet_ids                      # ALB 서브넷
  security_groups    = [aws_security_group.alb_security_group.id] # ALB 보안 그룹

  enable_deletion_protection       = each.value.alb_enable_deletion_protection       # 삭제 방지 활성화 여부
  enable_cross_zone_load_balancing = each.value.alb_enable_cross_zone_load_balancing # Cross-Zone 트래픽 분배 활성화 여부
  idle_timeout                     = each.value.alb_idle_timeout                     # 타임아웃 유휴시간 지정

  tags = merge(var.tags, {
    Name = "${each.value.alb_name}-${each.value.env}"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# ALB Listener 생성
resource "aws_lb_listener" "alb_listener" {
  for_each = var.alb_listener

  load_balancer_arn = aws_lb.alb[each.value.load_balancer_arn].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = each.value.default_action.type
    target_group_arn = aws_lb_target_group.target_group[each.value.default_action.target_group_arn].arn
  }

  tags = merge(var.tags, {
    Name = "${each.value.name}-${each.value.env}"
  })

  depends_on = [aws_lb.alb]

  lifecycle {
    prevent_destroy = true
  }
}

# ALB Listener Rule 생성
resource "aws_lb_listener_rule" "alb_listener_rule" {
  for_each = var.alb_listener_rule

  listener_arn = aws_lb_listener.alb_listener[each.key].arn
  priority     = each.value.priority

  condition {
    path_pattern {
      values = each.value.path # ALB Rule URL 경로 조건
    }
  }

  action {
    type             = each.value.type
    target_group_arn = aws_lb_target_group.target_group[each.value.target_group_name].arn # -> TODO: 해석
  }

  depends_on = [
    aws_lb.alb,
    aws_lb_listener.alb_listener
  ]

  lifecycle {
    prevent_destroy = true
  }
}

# ALB Target Group 생성
resource "aws_lb_target_group" "target_group" {
  for_each = var.target_group

  vpc_id      = var.vpc_id                                                    # VPC ID 지정(외부 모듈 변수 or ??)
  name        = "${each.value.target_group_name}-${each.value.env}"           # Target Group 이름 지정(원하는 이름 지정)
  port        = each.value.target_group_port                                  # Target Group Port 지정
  protocol    = each.value.target_group_target_type == "ALB" ? "HTTP" : "TCP" # Target Group 타입이 ALB면 HTTP, 아니면 TCP(NLB)
  target_type = each.value.target_group_target_type                           # Target Group 타입 지정(IP, 인스턴스, ALB..)

  # Target Group health checking
  health_check {
    enabled             = each.value.health_check.enabled                               # Health Check 옵션 활성화 여부
    healthy_threshold   = each.value.health_check.healthy_threshold                     # 타겟 정상 상태 간주 Health Check 횟수
    interval            = each.value.health_check.interval                              # Health Check 반복 횟수
    port                = each.value.health_check.port                                  # Health Check를 수행할 타겟의 포트 번호.
    protocol            = each.value.target_group_target_type == "ALB" ? "HTTP" : "TCP" # Health Check 요청 프로토콜
    timeout             = each.value.health_check.timeout                               # Health Check 타임아웃 지정
    unhealthy_threshold = each.value.health_check.unhealthy_threshold                   # 타겟이 비정상(Unhealthy) 상태로 간주되기 위해 연속적으로 실패해야 하는 Health Check 횟수.
  }

  # Tag 지정
  tags = merge(var.tags, {
    Name = "${each.value.target_group_name}-${each.value.env}"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# ALB 보안그룹 생성
resource "aws_security_group" "alb_security_group" {
  name        = var.alb_security_group
  description = "Allow Public inbound traffic and outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.alb_security_group}-${var.env}"
  })
}

# ALB 보안그룹 Rule 생성
resource "aws_security_group_rule" "alb_security_group_rule" {
  for_each = local.alb_security_group_rules.ingress_rules

  description       = "Allow Public inbound traffic and outbound traffic"
  security_group_id = aws_security_group.alb_security_group.id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.ip_protocol

  cidr_blocks = try([each.value.cidr_ipv4], null)
}