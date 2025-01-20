####################
# Child 모듈 ECS Terraform 변수
####################

####################
# 프로젝트 기본 설정
####################
# 프로젝트 이름
variable "project_name" {
  description = "프로젝트 이름 설정"
  type        = string
  default     = "terraform-ecs"
}

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

# AWS 가용영역
variable "availability_zones" {
  description = "가용 영역 설정"
  type        = list(string)
}

# AWS 계정 ID
variable "aws_account" {
  description = "AWS 계정 ID 설정"
  type        = string
}

# AWS 개발 환경
variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
  default     = "stage"
}

####################
# 네트워크 설정
####################
variable "vpc_id" {
  description = "VPC ID 설정"
  type        = string
}

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

# 퍼블릭 서브넷 ID
variable "public_subnet_ids" {
  description = "퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])"
  type        = list(string)
}

# 프라이빗 서브넷 ID
variable "private_subnet_ids" {
  description = "프라이빗 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])"
  type        = list(string)
}

################################
# Modules - ECS                #
################################
# ECS Clusters
variable "ecs_cluster" {
  description = "ECS Cluster 설정"
  type = map(object({
    cluster_name = string
    env          = string
  }))
}

# ECS Service 보안그룹
variable "ecs_security_group" {
  description = "ECS Service 보안그룹 설정"
  type        = string
}

# ECS Task role arn
variable "ecs_task_role_arn" {
  description = "security module에서 생성된 role arn을 참조"
  type        = string
}

# ECS Task exec role arn
variable "ecs_task_exec_role_arn" {
  description = "security module에서 생성된 role arn을 참조"
  type        = string
}

# AWS ECS Task
variable "ecs_task_definitions" {
  description = "ECS Task Definition 설정"
  type = map(object({
    name                                    = string
    task_role                               = string
    task_exec_role                          = string
    network_mode                            = string
    launch_type                             = string
    task_total_cpu                          = string
    task_total_memory                       = string
    runtime_platform_oprating_system_family = string
    runtime_platform_cpu_architecture       = string
    task_family                             = string
    cpu                                     = number
    memory                                  = number
    env                                     = string
    ephemeral_storage                       = number
    containers = list(object({
      name          = string
      image         = string
      version       = string
      cpu           = number
      memory        = number
      port          = number
      essential     = bool
      env_variables = map(string)
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

# ECS Service
variable "ecs_service" {
  description = "AWS ECS 서비스 목록"
  type = map(object({
    service_role                  = string # ECS Service Role
    cluster_name                  = string # ECS Cluster Name
    service_name                  = string # ECS 서비스 도메인명
    desired_count                 = number # ECS 서비스 Task 개수
    container_name                = string # ECS Container Name
    container_port                = number # ALB Listen Container Port
    task_definitions              = string
    env                           = string
    health_check_grace_period_sec = number # 헬스 체크 그레이스 기간
    assign_public_ip              = bool   # 퍼블릭 IP 지정 여부
    deployment_controller         = string
    launch_type                   = string
  }))
}

####################
# 로드밸런서 설정
####################

# ECS Service에서 사용하는 ALB TG ARN으로, loadbalancer module에서 리소스 생성 후 외부 변수로 받는다
variable "alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = map(string)
}

# ECS Service에서 사용하는 ALB ARN으로, loadbalancer module에서 리소스 생성 후 외부 변수로 받는다
variable "alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = map(string)
}

# ECS에서 사용하는 ALB 보안 그룹 ID
variable "alb_security_group_id" {
  description = "ECS에서 사용하는 ALB 보안 그룹 ID"
  type        = string
}

####################
# 공통 태그 설정
####################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}