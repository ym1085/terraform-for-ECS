output "alb_arns" {
  value = {
    for key, alb in aws_lb.alb : key => alb.arn
  }
}

output "alb_dns_names" {
  value = {
    for key, alb in aws_lb.alb : key => alb.dns_name
  }
}

output "alb_target_group_arn" {
  value = {
    for key, target_group in aws_lb_target_group.target_group : key => target_group.arn
  }
}

output "alb_listener_arn" {
  value = {
    for key, listener in aws_lb_listener.alb_listener : key => listener.arn
  }
}
