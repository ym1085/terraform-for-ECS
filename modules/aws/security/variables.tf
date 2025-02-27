####################
# IAM 설정
####################
variable "iam_role" {
  description = "IAM ROLE 설정"
  type = map(list(object({
    name        = optional(string)
    description = optional(string)
    version     = optional(string)
    statement = list(object({
      action = optional(string)
      effect = optional(string)
      principal = optional(object({
        service = optional(string)
      }))
    }))
  })))
}

variable "iam_policy" {
  description = "IAM POLICY 설정"
  type = map(list(object({
    name        = optional(string)
    description = optional(string)
    version     = optional(string)
    statement = optional(list(object({
      action   = optional(list(string))
      effect   = optional(string)
      resource = optional(list(string))
    })))
  })))
}

variable "iam_policy_attachment" {
  description = "IAM POLICY ATTACHMENT"
  type = map(list(object({
    role   = optional(string)
    policy = optional(string)
  })))
}

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

variable "ecs_auto_scaling_role" {
  description = "ECS Auto Scaling Role 설정"
  type        = string
}

variable "ecs_auto_scaling_policy_arn" {
  description = "ECS Auto Scaling Policy 설정"
  type        = string
}
