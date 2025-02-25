####################
# ROOT 모듈 전체 Terraform 변수
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

# AWS 리전
variable "aws_region" {
  description = "AWS 리전 설정"
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

# DNS Hostname 사용 옵션, 기본 false(VPC 내 리소스가 AWS DNS 주소 사용 가능)
variable "enable_dns_support" {
  description = "AWS DNS 사용 가능 여부 지정"
  type        = bool
}

# DNS hostname을 만들건지 안 만들건지 지정하는 옵션
# 결국 enable_dns_support, enable_dns_hostnames 옵션 2개다 켜야 DNS 통신 가능할 듯
variable "enable_dns_hostnames" {
  description = "DNS hostname 사용 가능 여부 지정"
  type        = bool
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
    alb_enable_deletion_protection       = bool
    alb_enable_cross_zone_load_balancing = bool
    alb_idle_timeout                     = number
    env                                  = string
  }))
}

# ALB 보안그룹 이름
variable "alb_security_group" {
  description = "ALB 보안그룹 이름"
  type        = string
  default     = "search-alb-sg"
}

# ALB Listencer
variable "alb_listener" {
  description = "ALB Listener 설정"
  type = map(object({
    name              = string
    port              = number
    protocol          = string
    load_balancer_arn = string
    default_action = object({
      type             = string
      target_group_arn = string
    })
    env = string
  }))
}

# ALB Listener Rule 생성
variable "alb_listener_rule" {
  description = "ALB Listener rule 설정"
  type = map(object({
    type              = string
    path              = list(string)
    alb_listener_name = string
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
    env                      = string
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
  }))
}

####################
# ECR 설정
####################
# ECR 리포지토리 생성
variable "ecr_repository" {
  description = "ECR Private Image Repository 설정"
  type = map(object({
    ecr_repository_name      = string
    ecr_image_tag_mutability = string
    ecr_scan_on_push         = bool
    ecr_force_delete         = bool
    env                      = string
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
    env          = string
  }))
}

# ECS Service 보안그룹
variable "ecs_security_group" {
  description = "ECS Service 보안그룹 설정"
  type        = string
}

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

# ECS Container Image 버전
# Image 버전의 경우 사용자에게 직접 받아서 처리한다
variable "ecs_container_image_version" {
  description = "ECS Container의 이미지 버전"
  type        = string
}

# ECS Task Definitions 생성
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
      env = string
    }))
  }))
}

# ECS 서비스 생성
variable "ecs_service" {
  description = "ECS 서비스 설정"
  type = map(object({
    service_role                  = string # ECS Service Role
    cluster_name                  = string
    service_name                  = string # ECS 서비스 도메인명
    desired_count                 = number # ECS 서비스 Task 개수
    container_name                = string # ECS Container Name
    container_port                = number # ALB Listen Container Port
    task_definitions              = string
    env                           = string
    health_check_grace_period_sec = number # 헬스 체크 그레이스 기간
    assign_public_ip              = bool   # 퍼블릭 IP 지정 여부
    deployment_controller         = string
    launch_type                   = string # ECS Launch Type ( EC2 or Fargate )
    target_group_arn              = string
  }))
}

# ECS Auto Scaling 시 사용하는 변수
variable "ecs_appautoscaling_target" {
  description = "ECS Auto Scaling Target 설정"
  type = map(object({
    min_capacity          = number # 최소 Task 2개가 항상 실행되도록 설정
    max_capacity          = number # 최대 Task 6개까지 증가 할 수 있도록 설정
    resource_id           = string # AG를 적용할 대상 리소스 지정, 여기서는 ECS 서비스 ARN 형식의 일부 기재
    scalable_dimension    = string # 조정할 수 있는 AWS 리소스의 특정 속성을 지정하는 필드
    service_namespace     = string
    scale_out_policy_name = string
    scale_in_policy_name  = string
    cluster_name          = string # AG가 어떤 ecs cluster에 매핑되는지 ecs cluster의 이름 지정
    service_name          = string # AG가 어떤 ecs service에 매핑되는지 ecs service의 이름 지정
  }))
}

# ECS Auto Scaling policy
variable "ecs_appautoscaling_target_policy" {
  description = "ECS Auto Scaling Target Policy 설정"
  type = map(object({
    scale_out = object({
      name        = string
      policy_type = string
      step_scaling_policy_conf = object({
        adjustment_type         = string
        cooldown                = number
        metric_aggregation_type = string
        step_adjustment = map(object({
          metric_interval_lower_bound = number
          metric_interval_upper_bound = optional(number)
          scaling_adjustment          = number
        }))
      })
    })
  }))
}

# ECS CPU Scale Out Alert
variable "ecs_cpu_scale_out_alert" {
  description = "ECS CPU Scale Out Alert Policy"
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = string
    metric_name         = string
    namespace           = string
    period              = string
    statistic           = string
    threshold           = string
    dimensions = object({
      cluster_name = string
      service_name = string
    })
    env = string
  }))
}

################
# EC2 설정
################
# EC2 보안그룹 설정
variable "ec2_security_group" {
  description = "EC2 보안그룹 생성"
  type = map(object({
    create                         = optional(bool, true) # 기본값 true
    ec2_security_group_name        = optional(string)
    ec2_security_group_description = optional(string)
    env                            = optional(string)
  }))
}

# EC2 보안그룹 규칙 설정
variable "ec2_security_group_ingress_rules" {
  description = "EC2 보안그룹 Ingress 규칙 생성"
  type = map(list(object({
    create                   = optional(bool, true)
    ec2_security_group_name  = optional(string)       # 참조하는 보안그룹 이름 지정
    description              = optional(string)       # 보안그룹 규칙 설명
    type                     = optional(string)       # ingress, egress
    from_port                = optional(number)       # 포트 시작 범위
    to_port                  = optional(number)       # 포트 종료 범위
    protocol                 = optional(string)       # 프로토콜
    cidr_ipv4                = optional(list(string)) # 허용할 IP CIDR 대역 범위
    source_security_group_id = optional(string)       # 보안그룹을 참조하는 경우 사용
    env                      = optional(string)       # 환경변수
  })))
}

variable "ec2_security_group_egress_rules" {
  description = "EC2 보안그룹 Egress 규칙 생성"
  type = map(list(object({
    create                   = optional(bool, true)
    ec2_security_group_name  = optional(string)       # 참조하는 보안그룹 이름 지정
    description              = optional(string)       # 보안그룹 규칙 설명
    type                     = optional(string)       # ingress, egress
    from_port                = optional(number)       # 포트 시작 범위
    to_port                  = optional(number)       # 포트 종료 범위
    protocol                 = optional(string)       # 프로토콜
    cidr_ipv4                = optional(list(string)) # 허용할 IP CIDR 대역 범위
    source_security_group_id = optional(string)       # 보안그룹을 참조하는 경우 사용
    env                      = optional(string)       # 환경변수
  })))
}

# EC2 생성
variable "ec2_instance" {
  description = "EC2 생성 정보 입력"
  type = map(object({
    # Option
    create = bool # EC2 인스턴스 생성 여부 지정

    # SSH key pair
    key_pair_name         = string
    key_pair_algorithm    = string
    rsa_bits              = number
    local_file_name       = string
    local_file_permission = string

    # ECS Option
    instance_type               = string
    subnet_type                 = string
    availability_zones          = string
    associate_public_ip_address = bool
    disable_api_termination     = bool
    ec2_instance_name           = string
    ec2_security_group_name     = string
    env                         = string
    script_file_name            = optional(string)
  }))
}

################
# S3 설정
################
variable "s3_bucket" {
  description = "생성하고자 하는 S3 버킷 정보 기재"
  type = map(object({
    bucket_name = string
  }))
}

################
# CICD 설정
################
variable "code_commit" {
  description = "Codecommit 관련 정보 기재"
  type = map(object({
    repository_name = string
    description     = string
    default_branch  = string
    env             = string
  }))
}

####################
# 공통 태그 설정
####################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
