####################
# ECS 클러스터 설정
####################
# ECS Role
variable "ecs_task_role" {
  description = "ECS Task Role 설정"
  type        = string
}

variable "ecs_task_role_policy" {
  description = "ECS Task Policy 설정"
  type        = string
}

variable "ecs_task_exec_role" {
  description = "ECS Task Exec Role 설정"
  type        = string
}

variable "ecs_task_exec_role_policy" {
  description = "ECS Task Exec Policy 설정"
  type        = string
}