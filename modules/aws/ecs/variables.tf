################################
# COMMON                       #
################################
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

# AWS Account
variable "aws_account" {
  description = "AWS Account ID"
  type        = string
}

# AWS Environments
variable "environment" {
  description = "AWS 환경 변수"
  type        = string
}

################################
# Modules - VPC                #
################################
# AWS Private Subnets
variable "vpc_private_subnet_ids" {
  description = "AWS private subnets 대역"
  type        = list(string)
}

################################
# Modules - ECS                #
################################
# AWS ECS Task Role
variable "ecs_task_role" {
  description = "AWS ECS Task Role"
  type        = string
}

# AWS ECS Task Execute Role
variable "ecs_task_exec_role" {
  description = "AWS ECS Task Execution Role"
  type        = string
}

# AWS ECS Service Role
variable "ecs_service_role" {
  description = "AWS ECS Service Role"
  type        = string
  default     = "AWSServiceRoleForECS"
}

# AWS ECS Network Mode
variable "ecs_network_mode" {
  description = "AWS ECS Network Mode"
  type        = string
  default     = "awsvpc"
}

# AWS ECS Launch Type
variable "ecs_launch_type" {
  description = "AWS ECS Launch Type"
  type        = string
  default     = "FARGATE"
}

# AWS ECS Task Definition Total Cpu
variable "ecs_task_total_cpu" {
  description = "AWS ECS Task Total CPU"
  type        = number
}

# AWS ECS Task Definition Total Mem
variable "ecs_task_total_memory" {
  description = "AWS ECS Task Total Memory"
  type        = number
}

# AWS ALB TG ARN
variable "alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = string
}

# AWS ALB Listener ARN
variable "alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = string
}

# AWS ECS Task Definition OS
variable "runtime_platform_oprating_system_family" {
  description = "AWS ECS Runtime Platform OS"
  type        = string
}

# AWS ECS Task Definition CPU Archi
variable "runtime_platform_cpu_architecture" {
  description = "AWS ECS Runtime Platform CPU"
  type        = string
}

# AWS ECS Deployment Controller
variable "ecs_deployment_controller" {
  description = "AWS ECS Deployment Controller"
  type        = string
}

# AWS ECS Task Security Group
variable "ecs_task_sg_id" {
  description = "AWS ECS Task SG"
  type        = string
}

# AWS ECS Cluster Name
variable "ecs_cluster_name" {
  description = "AWS ECS Cluster Name"
  type        = string
}

# AWS ECR Image version
# latest 사용은 지양하는게 좋을 것으로 보임, 버전 관리도 못함
# ecr image version의 경우 관리자가 입력하도록 하는게 좋을 듯
variable "ecs_task_ecr_image_version" {
  description = "AWS ECS ECR Image version"
  type        = string
}

# AWS ECS Task
variable "ecs_task_definitions" {
  description = "Task Definitions with multiple containers"
  type = map(object({
    task_family = string
    cpu         = number
    memory      = number
    environment = string
    ephemeral_storage = object({
      size_in_gib = number
    })
    containers = list(object({
      name                  = string
      image                 = string
      version               = string
      cpu                   = number
      memory                = number
      port                  = number
      essential             = bool
      environment_variables = map(string)
      mount_points = list(object({
        sourceVolume  = string
        containerPath = string
        readOnly      = bool
      }))
      health_check = object({
        command  = string
        interval = number
        timeout  = number
        retries  = number
      })
    }))
  }))
}

# AWS ECS Service
variable "ecs_service" {
  description = "AWS ECS 서비스 목록"
  type = map(object({
    ecs_service_name               = string      # ECS 서비스 도메인명
    ecs_service_task_desired_count = number      # ECS 서비스 Task 개수
    ecs_service_container_name     = string      # ECS Container Name
    ecs_service_container_port     = number      # ALB Listen Container Port
    health_check_grace_period_sec  = number      # 헬스 체크 그레이스 기간
    tags                           = map(string) # Optional : 추가 태그
  }))
}
