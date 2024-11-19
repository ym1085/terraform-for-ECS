data "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role
}

data "aws_iam_role" "ecs_task_exec_role" {
  name = var.ecs_task_exec_role
}

data "template_file" "container_definitions" {
  for_each = tomap(var.ecs_task_definitions) # for_each로 반복할 맵 정의
  template = file("${path.module}/task_definitions.tpl")

  vars = {
    containers = each.value.containers
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each = var.ecs_task_definitions

  family                   = each.value.ecs_task_definition_name
  cpu                      = var.ecs_task_total_cpu
  memory                   = var.ecs_task_total_memory
  network_mode             = var.ecs_network_mode
  requires_compatibilities = [var.ecs_launch_type] # EC2, FARATE

  # ECS Role
  task_role_arn      = data.aws_iam_role.ecs_task_role.arn
  execution_role_arn = data.aws_iam_role.ecs_task_exec_role.arn

  runtime_platform {
    operating_system_family = var.runtime_platform_oprating_system_family
    cpu_architecture        = var.runtime_platform_cpu_architecture
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
    size_in_gib = each.value.ephemeral_storage.size_in_gib
  }

  # ECS Task Definition 파일을 읽어서, 
  container_definitions = data.template_file.container_definitions[each.key].rendered
}

resource "aws_ecs_service" "ecs_service" {
  for_each = var.ecs_service

  cluster                           = "${var.ecs_cluster_name}-${var.environment}"              # ECS 클러스터 이름
  launch_type                       = var.ecs_launch_type                                       # ECS 런치 타입
  iam_role                          = var.ecs_service_role                                      # IAM Role
  name                              = each.value.ecs_service_name                               # ECS 서비스 이름
  desired_count                     = each.value.ecs_service_task_desired_count                 # 원하는 태스크 개수
  health_check_grace_period_seconds = each.value.health_check_grace_period_sec                  # 헬스 체크 그레이스 기간
  task_definition                   = aws_ecs_task_definition.ecs_task_definition[each.key].arn # Task Definition ARN

  # 네트워크 구성 (Private Subnet 사용)
  network_configuration {
    subnets          = var.vpc_private_subnet_ids
    security_groups  = [var.ecs_task_sg_id]
    assign_public_ip = false
  }

  # ALB와 연동된 Load Balancer 설정
  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = each.value.ecs_service_container_name
    container_port   = each.value.ecs_service_container_port
  }

  # 배포 회로 차단기 및 롤백
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # 배포 컨트롤러 설정
  deployment_controller {
    type = var.ecs_deployment_controller
  }

  tags = each.value.tags # 태그 설정
}
