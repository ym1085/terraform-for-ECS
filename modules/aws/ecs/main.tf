# ECS Task Role / ECS Container -> 타 서비스 접근
data "aws_iam_role" "ecs_task_role" {
  name = var.search_recommand_resource_acl_20221114
}

# ECS Task Exec Role / ECS Agent Container 실행
data "aws_iam_role" "ecs_task_exec_role" {
  name = var.search_recommand_resource_acl_20221114
}

data "aws_iam_role" "ecs_task_role" {
  name = var.search_recommand_resource_acl_20221114
}

# ECS Core Task Definition
resource "aws_ecs_task_definition" "core_ecs_task_definition" {
  for_each = var.core_ecs_task

  family                   = each.value.ecs_task_defintion_name
  cpu                      = each.value.ecs_task_container_cpu
  memory                   = each.value.ecs_task_container_mem
  network_mode             = var.ecs_network_mode
  requires_compatibilities = [var.ecs_launch_type] # EC2, FARATE

  # ECS Role
  task_role_arn      = data.aws_iam_role.ecs_task_role
  execution_role_arn = data.aws_iam_role.ecs_task_exec_role

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }

  # task_definitions.tpl 파일에 있는 mountPoints 이름을 volume으로 사용
  # ECS Fargate의 경우 volume 사용이 불가능하여, bind mount(host path) 사용
  volume {
    name = "core-shared-volume"
  }

  # ECS 임시 휘발성 볼륨 지정
  ephemeral_storage {
    size_in_gib = 21 # 21Gib (최소 볼륨)
  }

  container_definitions = data.template_file
}

resource "aws_ecs_service" "ecs_core_service_test" {
  for_each = var.core_ecs_service

  cluster                           = "${var.core_ecs_cluster_name}-${var.environment}"
  launch_type                       = var.ecs_launch_type
  iam_role                          = var.ecs_service_role
  name                              = each.value.ecs_service_name
  desired_count                     = each.value.ecs_service_task_desired_count
  health_check_grace_period_seconds = each.value.health_check_grace_period_sec
  task_definition                   = aws_ecs_task_definition.core_ecs_task_definition.arn

  # ECS Task 구동되는 영역(Private Subnet)
  network_configuration {
    subnets          = var.vpc_private_subnet_ids
    security_groups  = [var.core_ecs_task_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.core_alb_tg_arn
    container_name   = each.value.ecs_service_container_name
    container_port   = each.value.ecs_service_container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS" // Rolling Update
    // type = "CODE_DEPLOY"
  }

  tags = {
    "createdby"    = "ymkim1085@funin.camp"
    "env"          = "stage"
    "map-migrated" = "d-server-00pq62lmigxr9w"
    "service"      = "search-recommend"
    "servicetag"   = "search-e-d"
    "servicetype"  = "ecs-service"
    "teamtag"      = "AG"
  }

  depends_on = [
    var.core_alb_listener_arn
  ]
}
