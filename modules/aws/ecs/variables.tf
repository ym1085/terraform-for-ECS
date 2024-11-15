# AWS Account
# 파라미터 입력 필요 : o
variable "aws_account" {
  description = "AWS Account ID"
  type        = string
}

# AWS ECS Task Role
# 파라미터 입력 필요 : x
variable "ecs_task_role" {
  description = "AWS ECS Task Role"
  type        = string
  default     = "ecs_task_role"
}

# AWS ECS Task Execute Role
# 파라미터 입력 필요 : x
variable "ecs_task_exec_role" {
  description = "AWS ECS Task Execution Role"
  type        = string
  default     = "ecs_task_exec_role"
}

# AWS Private Subnets
# 파라미터 입력 필요 : o
variable "vpc_private_subnet_ids" {
  description = "AWS private subnets 대역"
  type        = list(string)
}

# AWS Environments
# 파라미터 입력 필요 : o
variable "environment" {
  description = "AWS 환경 변수"
  type        = string
}

# AWS ECS Network Mode
# 파라미터 입력 필요 : x
variable "ecs_network_mode" {
  description = "AWS ECS Network Mode"
  type        = string
  default     = "awsvpc"
}

# AWS ECS Launch Type
# 파라미터 입력 필요 : x
variable "ecs_launch_type" {
  description = "AWS ECS Launch Type"
  type        = string
  default     = "FARGATE"
}

# AWS ECS Service Role
# 파라미터 입력 필요 : x
variable "ecs_service_role" {
  description = "AWS ECS Service Role"
  type        = string
  default     = "AWSServiceRoleForECS"
}

# AWS ECS Task Definition Total Cpu
# 파라미터 입력 필요 : o
variable "ecs_task_total_cpu" {
  description = "AWS ECS Task Total CPU"
  type        = number
}

# AWS ECS Task Definition Total Mem
# 파라미터 입력 필요 : o
variable "ecs_task_total_memory" {
  description = "AWS ECS Task Total Memory"
  type        = number
}

# AWS ALB ARN
# 파라미터 입력 필요 : o
variable "alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = string
}

# AWS ECS Deployment Controller
# 파라미터 입력 필요 : o
variable "ecs_deployment_controller" {
  description = "AWS ECS Deployment Controller"
  type        = string
  default     = "ECS" # ECS or CODE_DEPLOY
}

# AWS ALB Listener ARN
# 파라미터 입력 필요 : o
variable "alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = string
}

# AWS ECS Task Security Group
# 파라미터 입력 필요 : x
variable "ecs_task_sg_id" {
  description = "AWS ECS Task별 보안그룹 id"
  type        = string
  default     = "search-search-api-SG"
}

# AWS ECS Cluster Name
# 파라미터 입력 필요 : x
variable "ecs_cluster_name" {
  description = "AWS ECS 클러스터명"
  type        = string
  default     = "search-ai-engine-cluster-stg"
}

# AWS ECR Image version
# latest 사용은 지양하는게 좋을 것으로 보임, 버전 관리도 못함
# ecr image version의 경우 관리자가 입력하도록 하는게 좋을 듯
variable "ecs_task_ecr_image_version" {
  description = "AWS ECS ECR Image version"
  type        = string
  default     = "latest" # image version default
}

# AWS ECS Task
# 파라미터 입력 필요 : x
# TODO: defult는 따로 빼야함
variable "ecs_task_option" {
  description = "AWS ECS task 목록"
  type = map(object({
    ecs_task_definition_name                     = string
    ecs_task_api_image_arn                       = string
    ecs_task_api_container_cpu                   = number
    ecs_task_api_container_mem                   = number
    ecs_task_api_container_name                  = string
    ecs_task_api_container_port                  = number
    ecs_task_api_environment                     = string
    ecs_task_api_essential                       = bool
    ecs_task_api_container_health_check_url      = string
    ecs_task_api_container_health_check_interval = number
  }))
  default = {
    "core-search-api-server" = {
      ecs_task_definition_name                     = "core-search-ai-engine-td-test",
      ecs_task_api_image_arn                       = "dkr.ecr.ap-northeast-2.amazonaws.com/search-search-api-server-stage",
      ecs_task_api_container_cpu                   = 256,
      ecs_task_api_container_mem                   = 512,
      ecs_task_api_container_name                  = "core-search-api-server",
      ecs_task_api_container_port                  = 10091,
      ecs_task_api_environment                     = "stage",
      ecs_task_api_essential                       = true,
      ecs_task_api_container_health_check_url      = "curl --location --request GET 'http://127.0.0.1:10091/explore/health-check' --header 'x-request-svc: MS_9999' --header 'Content-Type: application/json' || exit 1",
      ecs_task_api_container_health_check_interval = 30,
      ecs_task_api_container_health_check_timeout  = 10,
      ecs_task_api_container_health_check_retries  = 5,
      ecs_task_filebeat_image_arn                  = "dkr.ecr.ap-northeast-2.amazonaws.com/search-filebeat-stage", // filebeat
      ecs_task_filebat_container_cpu               = "256",
      ecs_task_filebeat_container_mem              = "512",
      ecs_task_filebeat_container_name             = "core-filebeat",
      ecs_task_filebeat_container_environment      = "stage",
      ecs_task_filebeat_essential                  = false,
      ecs_task_api_container_health_check_url      = "ps aux | grep '[f]ilebeat' || exit 1",
      ecs_task_api_container_health_check_interval = 30,
      ecs_task_api_container_health_check_timeout  = 10,
      ecs_task_api_container_health_check_retries  = 5
    },
    "core-meta-contents-api-server" = {
      ecs_task_definition_name                     = "core-meta-ai-engine-td-test",
      ecs_task_api_image_arn                       = "dkr.ecr.ap-northeast-2.amazonaws.com/search-meta-contents-api-server-stage",
      ecs_task_api_container_cpu                   = 256,
      ecs_task_api_container_mem                   = 512,
      ecs_task_api_container_name                  = "core-meta-contents-api-server",
      ecs_task_api_container_port                  = 10092,
      ecs_task_api_environment                     = "stage",
      ecs_task_api_essential                       = true,
      ecs_task_api_container_health_check_url      = "curl --location --request GET 'http://127.0.0.1:10092/meta-contents/health-check' --header 'x-request-svc: MS_9999' --header 'Content-Type: application/json' || exit 1",
      ecs_task_filebeat_image_arn                  = "dkr.ecr.ap-northeast-2.amazonaws.com/search-filebeat-stage",
      ecs_task_filebat_container_cpu               = "256",
      ecs_task_filebeat_container_mem              = "512",
      ecs_task_filebeat_container_name             = "core-filebeat",
      ecs_task_filebeat_container_environment      = "stage",
      ecs_task_filebeat_essential                  = false,
      ecs_task_api_container_health_check_url      = "ps aux | grep '[f]ilebeat' || exit 1",
      ecs_task_api_container_health_check_interval = 30,
      ecs_task_api_container_health_check_timeout  = 10,
      ecs_task_api_container_health_check_retries  = 5
    },
    "core-user-contents-api-server" = {
      ecs_task_definition_name                     = "core-user-ai-engine-td-test",
      ecs_task_api_image_arn                       = "dkr.ecr.ap-northeast-2.amazonaws.com/search-user-contents-api-server-stage",
      ecs_task_api_container_cpu                   = 256,
      ecs_task_api_container_mem                   = 512,
      ecs_task_api_container_name                  = "core-user-contents-api-server",
      ecs_task_api_container_port                  = 10093,
      ecs_task_api_environment                     = "stage",
      ecs_task_api_essential                       = true,
      ecs_task_api_container_health_check_url      = "curl --location --request GET 'http://127.0.0.1:10093/user-contents/health-check' --header 'x-request-svc: MS_9999' --header 'Content-Type: application/json' || exit 1",
      ecs_task_filebeat_image_arn                  = "dkr.ecr.ap-northeast-2.amazonaws.com/search-filebeat-stage",
      ecs_task_filebat_container_cpu               = "256",
      ecs_task_filebeat_container_mem              = "512",
      ecs_task_filebeat_container_name             = "core-filebeat",
      ecs_task_filebeat_container_environment      = "stage",
      ecs_task_filebeat_essential                  = false,
      ecs_task_api_container_health_check_url      = "ps aux | grep '[f]ilebeat' || exit 1",
      ecs_task_api_container_health_check_interval = 30,
      ecs_task_api_container_health_check_timeout  = 10,
      ecs_task_api_container_health_check_retries  = 5
    },
    "core-curation-api-server" = {
      ecs_task_definition_name                     = "core-curation-ai-engine-td-test",
      ecs_task_api_image_arn                       = "dkr.ecr.ap-northeast-2.amazonaws.com/search-curation-api-server-stage",
      ecs_task_api_container_cpu                   = 256,
      ecs_task_api_container_mem                   = 512,
      ecs_task_api_container_name                  = "core-curation-api-server",
      ecs_task_api_container_port                  = 10094,
      ecs_task_api_environment                     = "stage",
      ecs_task_api_essential                       = true,
      ecs_task_api_container_health_check_url      = "curl --location --request GET 'http://127.0.0.1:10094/curation/health-check' --header 'x-request-svc: MS_9999' --header 'Content-Type: application/json' || exit 1",
      ecs_task_filebeat_image_arn                  = "dkr.ecr.ap-northeast-2.amazonaws.com/search-filebeat-stage",
      ecs_task_filebat_container_cpu               = "256",
      ecs_task_filebeat_container_mem              = "512",
      ecs_task_filebeat_container_name             = "core-filebeat",
      ecs_task_filebeat_container_environment      = "stage",
      ecs_task_filebeat_essential                  = false,
      ecs_task_api_container_health_check_url      = "ps aux | grep '[f]ilebeat' || exit 1",
      ecs_task_api_container_health_check_interval = 30,
      ecs_task_api_container_health_check_timeout  = 10,
      ecs_task_api_container_health_check_retries  = 5
    }
  }
}

# Core ECS Service
# 파라미터 입력 필요 : x
variable "ecs_service_option" {
  description = "AWS ECS service 목록"
  type = map(object({
    ecs_service_name               = string # ECS 서비스 도메인명
    ecs_service_task_desired_count = number # ECS 서비스 Task 개수
    ecs_service_container_name     = string # ECS Container Name
    ecs_service_container_port     = number # ALB Listen Container Port
    health_check_grace_period_sec  = number # Optional: 헬스 체크 그레이스 기간
  }))
  default = {
    "search-api-service" = {
      ecs_service_name               = "core-search-ai-engine-service-test",
      ecs_service_task_desired_count = 1,
      ecs_service_container_name     = "search-search-api-server-stage",
      ecs_service_container_port     = 10091,
      health_check_grace_period_sec  = 120
    },
    "meta-contents-api-service" = {
      ecs_service_name               = "core-meta-ai-engine-service-test",
      ecs_service_task_desired_count = 1,
      ecs_service_container_name     = "search-meta-contents-api-server-stage",
      ecs_service_container_port     = 10092,
      health_check_grace_period_sec  = 120
    },
    "user-contents-api-service" = {
      ecs_service_name               = "core-user-ai-engine-service-test",
      ecs_service_task_desired_count = 1,
      ecs_service_container_name     = "search-user-contents-api-server-stage",
      ecs_service_container_port     = 10093,
      health_check_grace_period_sec  = 120
    },
    "curation-api-service" = {
      ecs_service_name               = "core-search-ai-engine-service-test",
      ecs_service_task_desired_count = 1,
      ecs_service_container_name     = "search-curation-api-server-stage",
      ecs_service_container_port     = 10094,
      health_check_grace_period_sec  = 120
    }
  }
}
