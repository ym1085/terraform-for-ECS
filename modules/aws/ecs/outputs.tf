# ECS Service 이름
output "ecs_service_name" {
  value = { for k, v in aws_ecs_service.ecs_service : k => v.ecs_service_name }
}

# ECS Task Definition 이름
output "ecs_task_definition" {
  value = { for k, v in aws_ecs_task_definition.ecs_task_definition : k => v.family }
}
