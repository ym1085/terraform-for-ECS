data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc-name"]
  }
}

module "alb" {
  source = "../../modules/aws/alb"

  vpc_id             = data.aws_vpc.vpc.id    # ALB 대상 ID
  alb_name           = var.alb_name           # ALB 이름
  alb_public_subnets = var.alb_public_subnets # ALB 퍼블릭 서브넷
  alb_sg_id          = var.alb_sg_id          # ALB 시큐리티 그룹
  alb_tg             = var.alb_tg             # ALB TG ID

}

module "ecs" {
  source = "../../modules/aws/ecs"

  aws_region                              = var.aws_region
  aws_account                             = var.aws_account
  environment                             = var.environment
  vpc_private_subnet_ids                  = var.vpc_private_subnet_ids
  ecs_task_role                           = var.ecs_task_role
  ecs_task_exec_role                      = var.ecs_task_exec_role
  ecs_service_role                        = var.ecs_service_role
  ecs_network_mode                        = var.ecs_network_mode
  ecs_launch_type                         = var.ecs_launch_type
  ecs_task_total_cpu                      = var.ecs_task_total_cpu
  ecs_task_total_memory                   = var.ecs_task_total_memory
  runtime_platform_oprating_system_family = var.runtime_platform_oprating_system_family
  runtime_platform_cpu_architecture       = var.runtime_platform_cpu_architecture
  ecs_deployment_controller               = var.ecs_deployment_controller
  ecs_task_sg_id                          = var.ecs_task_sg_id
  ecs_cluster_name                        = var.ecs_cluster_name
  ecs_task_ecr_image_version              = var.ecs_task_ecr_image_version # 관리자 입력 값
  ecs_task_definitions                    = var.ecs_task_definitions
  ecs_service                             = var.ecs_service
}
