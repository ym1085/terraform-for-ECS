####################
# 프로젝트 기본 설정
####################
# 프로젝트 이름
variable "project_name" {
  description = "프로젝트 이름 설정"
  type        = string
  default     = "terraform-eks"
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
# VPC ID(이미 생성되어 있는 VPC ID를 data 통해 받아오거나, 아니면 생성된 VPC ID를 넣는다)
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

####################
# 로드밸런서 설정
####################

# Application Load Balancer
# ALB의 KEY 이름과, Target Group 변수의 KEY 이름을 일치시켜야 함
variable "alb" {
  description = "ALB 설정"
  type = map(object({
    alb_name                             = string
    alb_internal                         = bool
    alb_load_balancer_type               = string
    alb_public_subnets                   = list(string)
    alb_sg_id                            = list(string)
    alb_enable_deletion_protection       = bool
    alb_enable_cross_zone_load_balancing = bool
    alb_idle_timeout                     = number
    environment                          = string
    tags                                 = map(string)
  }))
}

# ALB Listencer
variable "alb_listener" {
  description = "ALB Listener 설정"
  type = map(object({
    port              = number
    protocol          = string
    load_balancer_arn = string
    default_action = object({
      type             = string
      target_group_arn = string
    })
    tags = map(string)
  }))
}

# ALB Listener Rule 생성
variable "alb_listener_rule" {
  description = "ALB Listener rule 설정"
  type = map(object({
    type              = string
    path              = list(string)
    target_group_name = string
    priority          = number
  }))
}

# ALB Target Group 생성
# FIXME: 변수명 수정 필요 -> ALB야 아니면 NLB야? 정확히 명시
variable "target_group" {
  description = "ALB Target Group 설정"
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

####################
# ECR 설정
####################
variable "ecr_repository" {
  description = "ECR Private Image Repository 설정"
  type = map(object({
    ecr_repository_name      = string
    environment              = string
    ecr_image_tag_mutability = string
    ecr_scan_on_push         = bool
    ecr_force_delete         = bool
    tags                     = map(string)
  }))
}

####################
# ECS 클러스터 설정
####################
# ECS 클러스터 생성
variable "ecs_cluster" {
  description = "ECS Cluster 설정"
  type = map(object({
    cluster_name = string
    environment  = string
    tags         = map(string)
  }))
}

# ECS 서비스 생성
variable "ecs_service" {
  description = "ECS 서비스 설정"
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

# ECS Task Definitions 생성
variable "ecs_task_definitions" {
  description = "ECS Task Definition 설정"
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

#####
# FIXME: 아래 변수는 terraform.tfvars 외부 파라미터를 통해 받아서 사용하는 변수가 아님
# 추후 아래 변수 사용 목적/용도 확인 후 외부 파라미터로 받든, 다른 방법을 통해 진행
#####

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

variable "ecs_task_ecr_image_version" {
  description = "AWS ECR Image Version"
  type        = string
}
