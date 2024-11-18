################################
# COMMON                       #
################################
variable "aws_region" {
  description = "AWS Default Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "aws_account" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "AWS Development Environment"
  type        = string
  default     = "dev"
}

################################
# Modules - VPC                #
################################
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_private_subnet_ids" {
  description = "AWS VPC Private Subnet"
  type        = list(string)
}

################################
# Modules - ALB                #
################################
variable "alb" {
  description = "Application Load Balancer configuration"
  type = map(object({
    alb_name                         = string
    alb_internal                     = bool
    alb_load_balancer_type           = string
    alb_private_subnets              = list(string)
    alb_public_subnets               = list(string)
    alb_sg_id                        = list(string)
    enable_deletion_protection       = bool
    enable_cross_zone_load_balancing = bool
    idle_timeout                     = number
    tags                             = map(string)
  }))
}

variable "alb_listener" {
  description = "ALB listener"
  type = map(object({
    port     = number
    protocol = string
    default_action = object({
      type = string
    })
    tags = map(string)
  }))
}

variable "alb_listener_rule" {
  description = "ALB listener rule"
  type = map(object({
    type              = string
    path              = list(string)
    target_group_name = string
    priority          = number
  }))
}

variable "target_group" {
  description = "Target group configuration"
  type = map(object({
    target_group_name        = string
    target_group_port        = number
    target_group_elb_type    = string
    target_group_target_type = string
    environment              = string
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      port                = number
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
      internal            = bool
    })
    tags = map(string)
  }))
}

################################
# Modules - ECS                #
################################
variable "ecs_task_role" {
  description = "AWS ECS Task Role"
  type        = string
}

variable "ecs_task_exec_role" {
  description = "AWS ECS Task Execution Role"
  type        = string
}

variable "ecs_service_role" {
  description = "AWS ECS Service Role"
  type        = string
  default     = "AWSServiceRoleForECS"
}

variable "ecs_network_mode" {
  description = "AWS ECS Network Mode"
  type        = string
  default     = "awsvpc"
}

variable "ecs_launch_type" {
  description = "AWS ECS Launch Type"
  type        = string
  default     = "FARGATE"
}

variable "ecs_task_total_cpu" {
  description = "AWS ECS Task Total CPU"
  type        = number
  default     = 256
}

variable "ecs_task_total_memory" {
  description = "AWS ECS Task Total Memory"
  type        = number
  default     = 512
}

variable "alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = string
}

variable "alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = string
}

variable "runtime_platform_oprating_system_family" {
  description = "AWS ECS Runtime Platform OS"
  type        = string
  default     = "LINUX"
}

variable "runtime_platform_cpu_architecture" {
  description = "AWS ECS Runtime Platform CPU"
  type        = string
  default     = "X86_64"
}

# CODE DEPLOY로 지정하려면 아래 타입 변경 필요
# ECS | CODE_DEPLOY | EXTERNAL
variable "ecs_deployment_controller" {
  description = "AWS ECS Deployment Controller"
  type        = string
  default     = "ECS"
}

variable "ecs_task_sg_id" {
  description = "AWS ECS Task SG"
  type        = string
}

variable "ecs_cluster_name" {
  description = "AWS ECS Cluster Name"
  type        = string
}

variable "ecs_task_ecr_image_version" {
  description = "AWS ECR Image Version"
  type        = string
}

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
