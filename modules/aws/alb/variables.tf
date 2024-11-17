variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb" {
  description = "ALB"
  type = map(object({
    alb_name                             = string
    alb_internal                         = bool
    alb_load_balancer_type               = string
    alb_public_subnets                   = list(string)
    alb_private_subnets                  = list(string)
    alb_sg_id                            = list(string)
    alb_enable_deletion_protection       = bool
    alb_enable_cross_zone_load_balancing = bool
    alb_idle_timeout                     = number
    tags                                 = map(string) # ALB 태그 지정
  }))
}

variable "alb_listener" {
  description = "ALB listener"
  type = map(object({
    port     = number
    protocol = string
    default_action = object({
      type = string
    })
    tags = map(string)
  }))
}

variable "alb_listener_rule" {
  description = "ALB listener rule"
  type = map(object({
    type              = string
    path              = list(string)
    target_group_name = string
    priority          = number
  }))
}

variable "target_group" {
  description = "Target Group"
  type = map(object({
    target_group_name        = string # Target Group 이름 지정(원하는 이름 지정)
    target_group_port        = number # Target Group Port(80, 443..)
    target_group_elb_type    = string # Target Group ELB 타입(ALB, NLB, ELB..)
    target_group_target_type = string # Target Group 타겟 타입(IP, 인스턴스, ALB..)
    environment              = string # Target Group 환경 변수(PROD, STAGE..)
    health_check = object({           # Target Group 헬스 체크 관련 설정
      enabled             = bool
      healthy_threshold   = number
      internal            = number
      port                = number
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
    })
    tags = map(string) # Target Group 태그 지정
  }))
}
