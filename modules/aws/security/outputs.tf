# modules/aws/security/outputs.tf

# ECS Task Role
output "ecs_task_role_name" {
  description = "생성된 ECS Task Role 이름 반환"
  value       = aws_iam_role.ecs_task_role.name
}

# ECS Task Role ARN
output "ecs_task_role_arn" {
  description = "생성된 ECS Task Role ARN 반환"
  value       = aws_iam_role.ecs_task_role.arn
}

# ECS Task Role Policy
output "ecs_task_role_policy_name" {
  description = "생성된 ECS Task Role Policy 이름 반환"
  value       = aws_iam_policy.ecs_task_role_policy.name
}

# ECS Task Role Policy ARN
output "ecs_task_role_policy_arn" {
  description = "생성된 ECS Task Role Policy ARN 반환"
  value       = aws_iam_policy.ecs_task_role_policy.arn
}

# ECS Task Exec Role
output "ecs_task_exec_role_name" {
  value       = aws_iam_role.ecs_task_exec_role.name
  description = "Name of the ECS Task Execution Role"
}

output "ecs_task_exec_role_arn" {
  value       = aws_iam_role.ecs_task_exec_role.arn
  description = "ARN of the ECS Task Execution Role"
}

# ECS Task Exec Role Policy
output "ecs_task_exec_role_policy_name" {
  value       = aws_iam_policy.ecs_task_exec_role_policy.name
  description = "Name of the ECS Task Execution Role Policy"
}

output "ecs_task_exec_role_policy_arn" {
  value       = aws_iam_policy.ecs_task_exec_role_policy.arn
  description = "ARN of the ECS Task Execution Role Policy"
}