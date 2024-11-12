
# AWS ALB DNS
output "alb_dns_nam" {
  value = aws_lb.core-api-alb-test.dns_name
}

# AWS ALB Listener ARN
output "alb_listener_arn" {
  value = aws_lb_listener.core-api-alb-listener-test.arn
}

# AWS Target Group ARN
output "alb_target_group_arn" {
  value = aws_lb_target_group.core-api-tg-test.arn
}
