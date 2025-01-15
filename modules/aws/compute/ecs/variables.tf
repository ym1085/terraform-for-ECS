####################
# 프로젝트 기본 설정
####################
# AWS 가용영역
variable "aws_region" {
  description = "AWS 가용영역 설정"
  type        = string
  default     = "ap-northeast-2"
  validation {
    condition     = contains(["ap-northeast-2"], var.aws_region)
    error_message = "지원되지 않는 AWS 리전입니다."
  }
}

# AWS 계정 ID
variable "aws_account" {
  description = "AWS 계정 ID 설정"
  type        = string
}

# AWS 개발 환경
variable "environment" {
  description = "AWS 개발 환경 설정"
  type        = string
  default     = "stage"
}

####################
# 네트워크 설정
####################
# VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR 설정"
  type        = string
  default     = "172.22.0.0/16" # 2^16 => 65,536 / 가용영역(4개) => 16,384
}

# 퍼블릭 서브넷
variable "public_subnets_cidr" {
  description = "퍼블릭 서브넷 설정"
  type        = list(string)
}

# 프라이빗 서브넷
variable "private_subnets_cidr" {
  description = "프라이빗 서브넷 설정"
  type        = list(string)
}

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

variable "alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = map(string)
}

variable "alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = map(string)
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

# AWS ECR Image version
# latest 사용은 지양하는게 좋을 것으로 보임, 버전 관리도 못함
# ecr image version의 경우 관리자가 입력하도록 하는게 좋을 듯
variable "ecs_task_ecr_image_version" {
  description = "AWS ECS ECR Image version"
  type        = string
}

variable "ecs_cluster" {
  description = "ECS Cluster"
  type = map(object({
    cluster_name = string
    environment  = string
    tags         = map(string)
  }))
}

# AWS ECS Task
variable "ecs_task_definitions" {
  description = "Task Definitions with multiple containers"
  type = map(object({
    task_family       = string
    cpu               = number
    memory            = number
    environment       = string
    ephemeral_storage = number
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
    cluster_name                  = string
    service_name                  = string # ECS 서비스 도메인명
    desired_count                 = number # ECS 서비스 Task 개수
    container_name                = string # ECS Container Name
    container_port                = number # ALB Listen Container Port
    task_definitions              = string
    environment                   = string
    health_check_grace_period_sec = number      # 헬스 체크 그레이스 기간
    assign_public_ip              = bool        # 퍼블릭 IP 지정 여부
    tags                          = map(string) # Optional : 추가 태그
  }))
}
