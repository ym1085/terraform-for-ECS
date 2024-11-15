# AWS ALB DNS
output "core-api-alb-test.dns_name" {
  value = aws_lb.core-api-alb-test.dns_name
}

# AWS ALB Listener ARN
output "core-api-alb-listener-test" {
  value = aws_lb_listener.core-api-alb-listener-test.arn
}

# AWS Target Group ARN
output "core-api-tg-test.arn" {
  value = aws_lb_target_group.core-api-tg-test.arn
}
