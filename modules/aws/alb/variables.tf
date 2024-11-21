variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb" {
  description = "Application Load Balancer configuration"
  type = map(object({
    alb_name                             = string
    alb_internal                         = bool
    alb_load_balancer_type               = string
    alb_public_subnets                   = list(string)
    alb_sg_id                            = list(string)
    alb_enable_deletion_protection       = bool
    alb_enable_cross_zone_load_balancing = bool
    alb_idle_timeout                     = number
    environment                          = string
    tags                                 = map(string)
  }))
}

variable "alb_listener" {
  description = "ALB listener"
  type = map(object({
    port              = number
    protocol          = string
    load_balancer_arn = string
    default_action = object({
      type             = string
      target_group_arn = string
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
  description = "Target group configuration"
  type = map(object({
    target_group_name        = string
    target_group_port        = number
    target_group_elb_type    = string
    target_group_target_type = string
    environment              = string
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      port                = number
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
      internal            = bool
    })
    tags = map(string)
  }))
}
