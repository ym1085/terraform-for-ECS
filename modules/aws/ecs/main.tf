# ECS Task Role / ECS Container -> 타 서비스 접근
data "aws_iam_role" "ecs_task_role" {
  name = var.search_recommand_resource_acl_20221114
}

# ECS Task Exec Role / ECS Agent Container 실행
data "aws_iam_role" "ecs_task_exec_role" {
  name = var.search_recommand_resource_acl_20221114
}

# ECS Core Task Definition
resource "aws_ecs_task_definition" "core_ecs_task_definition" {
  family                   = todo
  task_role_arn            = data.aws_iam_role.ecs_task_role
  execution_role_arn       = data.aws_iam_role.ecs_task_exec_role
  network_mode             = var.ecs_network_mode
  requires_compatibilities = [var.ecs_launch_type]
  cpu                      = todo
  memory                   = todo

  container_definitions = data.template_file
}

resource "aws_ecs_service" "ecs_core_service_test" {
  for_each = { for idx, ecs_service in var.core_ecs_service : ecs_servicec.name => ecs_service }

  cluster                           = "${var.core_ecs_cluster_name}-${var.environment}"
  launch_type                       = var.ecs_launch_type
  iam_role                          = var.ecs_service_role
  name                              = each.value.ecs_service_name
  desired_count                     = each.value.ecs_service_task_desried_count
  health_check_grace_period_seconds = each.value.health_check_grace_period_sec
  task_definition                   = aws_ecs_task_definition.core_ecs_task_definition.arn

  # ECS Task 구동되는 영역(Private Subnet)
  network_configuration {
    subnets          = var.vpc_private_subnet_ids
    security_groups  = [var.core_ecs_task_sg_id]
    assign_public_ip = false
  }

  # TODO: 여러개의 LB 동적으로 생성 필요
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
