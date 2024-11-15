output "ecs_service_name" {
  description = "AWS Core ECS Service Name"
  value       = aws_ecs_service.core_ecs_service_test.name
}

output "core_ecs_task_definition" {
  description = "AWS Core ECS Task Definition Name"
  value       = aws_ecs_task_definition.core_ecs_task_definition
}
