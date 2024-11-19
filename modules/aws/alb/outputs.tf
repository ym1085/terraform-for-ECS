# ALB 도메인명 반환
output "alb_dns_name" {
  value = { for k, v in aws_lb.alb : k => v.dns_name }
}

# ALB Listener ARN 반환
output "alb_listener_arn" {
  value = { for k, v in aws_lb_listener.alb_listener : k => v.arn }
}

# Target Group ARN 반환
output "alb_target_group_arn" {
  value = { for k, v in aws_lb_target_group.target_group : k => v.arn }
}
