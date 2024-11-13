# AWS Service Assume Role
# Inject variables : x
variable "search_recommand_resource_acl_20221114" {
  description = "AWS 서비스 Assume Role, 해당 Role을 통해 여러 AWS 제어 중"
  default     = "Search_Recommand-ResourceACL_v1.0_20221114"
}

# AWS Private Subnets
# Inject variables : o
variable "vpc_private_subnet_ids" {
  description = "AWS private subnets 대역"
  type        = list(string)
}

# AWS Environments
# Inject variables : o
variable "environment" {
  description = "AWS 환경 변수"
  type        = string
}

# AWS ECS Network Mode
# Inject variables : x
variable "ecs_network_mode" {
  description = "AWS ECS Network Mode"
  type        = string
  default     = "awsvpc"
}

# AWS ECS Launch Type
# Inject variables : x
variable "ecs_launch_type" {
  description = "AWS ECS Launch Type"
  type        = string
  default     = "FARGATE"
}

# AWS ECS Service Role
# Inject variables : x
variable "ecs_service_role" {
  description = "AWS ECS Service Role"
  type        = string
  default     = "AWSServiceRoleForECS"
}

# AWS ECS API Name
# Inject variables : x
variable "core_api_name" {
  description = "AWS ECS API Name List"
  type        = list(string)
  default = [
    "search",
    "meta-contents",
    "user-contents",
    "curation"
  ]
}

# AWS ECS Task Definition Total Cpu
# Inject variables : x
variable "core_ecs_task_total_cpu" {
  description = "AWS ECS Task Total CPU"
  type        = number
  default     = 1024 # 1 vCPU
}

# AWS ECS Task Definition Total Mem
# Inject variables : x
variable "core_ecs_task_total_memory" {
  description = "AWS ECS Task Total Memory"
  type        = number
  default     = 2048 # 2 GB
}

# AWS ALB ARN
# Inject variables : o
variable "core_alb_tg_arn" {
  description = "AWS ECS ALB TG ARN"
  type        = string
}

# AWS ALB Listener ARN
# Inject variables : o
variable "core_alb_listener_arn" {
  description = "AWS ECS ALB LISTENER ARN"
  type        = string
}

# AWS ECS Task Security Group
# Inject variables : x
variable "core_ecs_task_sg_id" {
  description = "AWS ECS Task별 보안그룹 id"
  type        = string
  default     = "search-search-api-SG"
}

# AWS ECS Cluster Name
# Inject variables : x
variable "core_ecs_cluster_name" {
  description = "AWS ECS 클러스터명"
  type        = string
  default     = "search-ai-engine-cluster-stg"
}

# AWS ECS Task
# Inject variables : x
variable "core_ecs_task" {
  description = "AWS ECS task 목록"
  type = list(object({
    ecs_task_ecr_image_arn              = string
    ecs_task_container_cpu              = number
    ecs_task_container_mem              = number
    ecs_task_container_name             = string
    ecs_task_container_port             = number
    ecs_task_environment                = map(string)
    ecs_task_essential                  = bool
    ecs_task_container_health_check_url = string
  }))
  default = [
    {
      "ecs_task_ecr_image_arn" : "746920558207.dkr.ecr.ap-northeast-2.amazonaws.com/search-search-api-server-stage"
      "ecs_task_container_cpu" : "256"
      "ecs_task_container_mem" : "512"
      "ecs_task_container_name" : "core-search-api-server"
      "ecs_task_container_port" : "10091"
      "ecs_task_environment" : "stage"
      "ecs_task_essential" : true
      "ecs_task_container_health_check_url" : "curl --location --request GET 'http://127.0.0.1:10091/explore/health-check' \\\n--header 'x-request-svc: MS_9999' \\\n--header 'Content-Type: application/json' || exit 1"
    },
    {
      "ecs_task_ecr_image_arn" : "746920558207.dkr.ecr.ap-northeast-2.amazonaws.com/search-meta-contents-api-server-stage"
      "ecs_task_container_cpu" : "256"
      "ecs_task_container_mem" : "512"
      "ecs_task_container_name" : "core-meta-contents-api-server"
      "ecs_task_container_port" : "10092"
      "ecs_task_environment" : "stage"
      "ecs_task_essential" : true
      "ecs_task_container_health_check_url" : "curl --location --request GET 'http://127.0.0.1:10092/meta-contents/health-check' \\\n--header 'x-request-svc: MS_9999' \\\n--header 'Content-Type: application/json' || exit 1"
    },
    {
      "ecs_task_ecr_image_arn" : "746920558207.dkr.ecr.ap-northeast-2.amazonaws.com/search-user-contents-api-server-stage"
      "ecs_task_container_cpu" : "256"
      "ecs_task_container_mem" : "512"
      "ecs_task_container_name" : "core-user-contents-api-server"
      "ecs_task_container_port" : "10093"
      "ecs_task_environment" : "stage"
      "ecs_task_essential" : true
      "ecs_task_container_health_check_url" : "curl --location --request GET 'http://127.0.0.1:10093/user-contents/health-check' \\\n--header 'x-request-svc: MS_9999' \\\n--header 'Content-Type: application/json' || exit 1"
    },
    {
      "ecs_task_ecr_image_arn" : "746920558207.dkr.ecr.ap-northeast-2.amazonaws.com/search-curation-api-server-stage"
      "ecs_task_container_cpu" : "256"
      "ecs_task_container_mem" : "512"
      "ecs_task_container_name" : "core-curation-api-server"
      "ecs_task_container_port" : "10094"
      "ecs_task_environment" : "stage"
      "ecs_task_essential" : true
      "ecs_task_container_health_check_url" : "curl --location --request GET 'http://127.0.0.1:10094/curation/health-check' \\\n--header 'x-request-svc: MS_9999' \\\n--header 'Content-Type: application/json' || exit 1"
    }
  ]
}

# Core ECS Service
# Inject variables : x
variable "core_ecs_service" {
  description = "Core ECS service 목록"
  type = list(object({
    ecs_service_name               = string # ECS 서비스 도메인명
    ecs_service_task_desried_count = number # ECS 서비스 Task 개수
    ecs_service_container_name     = string # ECS Container Name
    ecs_service_container_port     = number # ALB Listen Container Port
  }))
  default = [
    {
      "ecs_service_name" : "core-search-ai-engine-service-test"
      "ecs_service_task_desried_count" : "1"
      "ecs_service_container_name" : "search-search-api-server-stage"
      "ecs_service_container_port" : "10091"
    },
    {
      "ecs_service_name" : "core-meta-ai-engine-service-test"
      "ecs_service_task_desried_count" : "1"
      "ecs_service_container_name" : "search-meta-contents-api-server-stage"
      "ecs_service_container_port" : "10092"
    },
    {
      "ecs_service_name" : "core-user-ai-engine-service-test"
      "ecs_service_task_desried_count" : "1"
      "ecs_service_container_name" : "search-user-contents-api-server-stage"
      "ecs_service_container_port" : "10093"
    },
    {
      "ecs_service_name" : "core-search-ai-engine-service-test"
      "ecs_service_task_desried_count" : "1"
      "ecs_service_container_name" : "search-curation-api-server-stage"
      "ecs_service_container_port" : "10094"
    }
  ]
}
