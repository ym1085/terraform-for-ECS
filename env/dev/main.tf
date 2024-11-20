# AWS VPC External
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"      # 필터링 조건은 VPC명
    values = ["default-vpc"] # 이미 생성되어 있는 VPC의 이름을 기반으로 VPC ID 조회
  }
}

# AWS ALB Modules
module "alb" {
  source = "../../modules/aws/alb"

  # vpc
  vpc_id = data.aws_vpc.vpc.id # ALB 대상 ID

  # alb & tg
  alb               = var.alb               # 생성을 원하는 ALB 관련 정보
  alb_listener      = var.alb_listener      # 위에서 생성한 ALB Listener 관련 정보
  alb_listener_rule = var.alb_listener_rule # ALB Listener Rule
  target_group      = var.target_group      # ALB의 Target Group
}

# module "ecr" {
#   source = "../../modules/aws/ecr"
# }

# AWS ECS Modules
module "ecs" {
  source = "../../modules/aws/ecs"

  # common
  aws_region  = var.aws_region
  aws_account = var.aws_account
  environment = var.environment

  # vpc
  vpc_private_subnet_ids = var.vpc_private_subnet_ids

  # ecs
  ecs_task_role         = var.ecs_task_role
  ecs_task_exec_role    = var.ecs_task_exec_role
  ecs_service_role      = var.ecs_service_role
  ecs_network_mode      = var.ecs_network_mode
  ecs_launch_type       = var.ecs_launch_type
  ecs_task_total_cpu    = var.ecs_task_total_cpu
  ecs_task_total_memory = var.ecs_task_total_memory

  alb_tg_arn       = module.alb.alb_target_group_arn
  alb_listener_arn = module.alb.alb_listener_arn

  runtime_platform_oprating_system_family = var.runtime_platform_oprating_system_family
  runtime_platform_cpu_architecture       = var.runtime_platform_cpu_architecture

  ecs_deployment_controller  = var.ecs_deployment_controller
  ecs_task_sg_id             = var.ecs_task_sg_id
  ecs_cluster_name           = var.ecs_cluster_name
  ecs_task_ecr_image_version = var.ecs_task_ecr_image_version
  ecs_task_definitions       = var.ecs_task_definitions
  ecs_service                = var.ecs_service

  depends_on = [module.alb]
}

output "debug_variables" {
  value = {
    alb_arns             = module.alb.alb_arns
    alb_dns_names        = module.alb.alb_dns_names
    alb_target_group_arn = module.alb.alb_target_group_arn
    alb_listener_arn     = module.alb.alb_listener_arn
  }
}

# 디버깅을 위한 output 추가
output "debug_ecs_variables" {
  value = {
    # vpc_private_subnet_ids = var.vpc_private_subnet_ids
    ecs_task_role    = var.ecs_task_role
    ecs_cluster_name = var.ecs_cluster_name
    alb_tg_arn       = module.alb.alb_target_group_arn
    alb_listener_arn = module.alb.alb_listener_arn
    # 필요한 다른 변수들도 추가 가능
  }
}
