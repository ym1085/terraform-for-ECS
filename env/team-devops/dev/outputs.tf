output "debug_network_module" {
  description = "network 모듈 변수 확인"
  value = {
    vpc_cidr             = var.vpc_cidr
    enable_dns_support   = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    public_subnets_cidr  = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    availability_zones   = var.availability_zones
  }
  sensitive = true
}

output "debug_load_balancer_module" {
  description = "load_balancer 모듈 변수 확인"
  value = {
    alb                = var.alb
    alb_listener       = var.alb_listener
    alb_listener_rule  = var.alb_listener_rule
    target_group       = var.target_group
    alb_security_group = var.alb_security_group
    public_subnet_ids  = module.network.public_subnet_ids
  }
  sensitive = true
}

output "debug_ecr_module" {
  description = "ecr 모듈 변수 확인"
  value = {
    ecr_repository = var.ecr_repository
  }
  sensitive = true
}

output "debug_security_module" {
  description = "security 모듈 변수 확인"
  value = {
    ecs_task_role               = var.ecs_task_role
    ecs_task_role_policy        = var.ecs_task_role_policy
    ecs_task_exec_role          = var.ecs_task_exec_role
    ecs_task_exec_role_policy   = var.ecs_task_exec_role_policy
    ecs_auto_scaling_role       = var.ecs_auto_scaling_role
    ecs_auto_scaling_policy_arn = var.ecs_auto_scaling_policy_arn
  }
  sensitive = true
}

output "debug_compute_module" {
  description = "compute 모듈 변수 확인"
  value = {
    vpc_id               = module.network.vpc_id
    public_subnets_cidr  = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    public_subnet_ids    = module.network.public_subnet_ids
    private_subnet_ids   = module.network.private_subnet_ids

    ecs_cluster                      = var.ecs_cluster
    ecs_task_definitions             = var.ecs_task_definitions
    ecs_service                      = var.ecs_service
    ecs_appautoscaling_target        = var.ecs_appautoscaling_target
    ecs_appautoscaling_target_policy = var.ecs_appautoscaling_target_policy
    ecs_cpu_scale_out_alert          = var.ecs_cpu_scale_out_alert

    ecs_task_role_arn           = module.security.ecs_task_role_arn
    ecs_task_exec_role_arn      = module.security.ecs_task_exec_role_arn
    ecs_security_group          = var.ecs_security_group
    ecs_container_image_version = var.ecs_container_image_version

    alb_tg_arn            = module.load_balancer.alb_target_group_arn
    alb_listener_arn      = module.load_balancer.alb_listener_arn
    alb_security_group_id = module.load_balancer.alb_security_group_id
  }
  sensitive = true
}

output "debug_ec2" {
  description = "ec2 모듈 변수 확인"
  value = {
    vpc_id            = module.network.vpc_id
    public_subnet_ids = module.network.public_subnet_ids

    ec2_security_group       = var.ec2_security_group
    ec2_security_group_rules = var.ec2_security_group_rules
    ec2_instance             = var.ec2_instance

    env  = var.env
    tags = var.tags
  }
}

output "debug_storage_module" {
  description = "storage 모듈 변수 확인"
  value = {
    s3_bucket = var.s3_bucket
  }
  sensitive = true
}
