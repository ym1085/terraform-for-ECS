# 기존에 생성되어 있는 ecs_task_role 참조
# data "aws_iam_role" "ecs_task_role" {
#   for_each = var.ecs_task_definitions
#   name     = each.value.task_role
# }

# 기존에 생성되어 있는 ecs_task_exec_role 참조
# data "aws_iam_role" "ecs_task_exec_role" {
#   for_each = var.ecs_task_definitions
#   name     = each.value.task_exec_role
# }

# ECS Task Definitions 템플릿 파일 생성
data "template_file" "container_definitions" {
  for_each = tomap(var.ecs_task_definitions) # for_each로 반복할 맵 정의
  template = file("${path.module}/task_definitions.tpl")

  vars = {
    containers                  = jsonencode(each.value.containers) # container 정보
    ecs_container_image_version = var.ecs_container_image_version   # container image version
  }
}

# ECS 클러스터
resource "aws_ecs_cluster" "ecs_cluster" {
  for_each = var.ecs_cluster
  name     = "${each.value.cluster_name}-${each.value.env}" # core-search-cluster-stg

  lifecycle {
    # prevent_destroy = true
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${each.value.cluster_name}-${each.value.env}"
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each = var.ecs_task_definitions

  family                   = "${each.value.task_family}-${each.value.env}"
  cpu                      = each.value.task_total_cpu
  memory                   = each.value.task_total_memory
  network_mode             = each.value.network_mode
  requires_compatibilities = [each.value.launch_type] # EC2, FARATE

  # ECS Task Role & Task Exec Role 설정
  task_role_arn      = var.ecs_task_role_arn
  execution_role_arn = var.ecs_task_exec_role_arn

  # (기존에 생성되어 있는 Role 참조)
  # task_role_arn      = data.aws_iam_role.ecs_task_role[each.value.name].arn
  # execution_role_arn = data.aws_iam_role.ecs_task_exec_role[each.value.name].arn

  runtime_platform {
    operating_system_family = each.value.runtime_platform_oprating_system_family
    cpu_architecture        = each.value.runtime_platform_cpu_architecture
  }

  lifecycle {
    ignore_changes = [container_definitions]
    # prevent_destroy = true # 삭제 방지
  }

  # task_definitions.tpl 파일에 있는 mountPoints 이름을 volume으로 사용
  # ECS Fargate의 경우 volume 사용이 불가능하여, bind mount(host path) 사용
  volume {
    name = "core-shared-volume"
  }

  # ECS 임시 휘발성 볼륨 지정
  ephemeral_storage {
    size_in_gib = each.value.ephemeral_storage
  }

  # ECS Task Definition 파일을 읽어서
  container_definitions = data.template_file.container_definitions[each.key].rendered

  tags = merge(var.tags, {
    Name = "${each.value.task_family}-${each.value.env}"
  })
}

# ECS 서비스
resource "aws_ecs_service" "ecs_service" {
  # ECS 서비스의 경우.. 우선 기본적으로 생성하지 않는다
  for_each = local.create_ecs_service ? var.ecs_service : {}

  launch_type                       = each.value.launch_type
  iam_role                          = each.value.service_role                                                      # IAM Role
  cluster                           = "${each.value.cluster_name}-${each.value.env}"                               # ECS 클러스터 이름
  name                              = "${each.value.service_name}-${each.value.env}"                               # ECS 서비스 이름
  desired_count                     = each.value.desired_count                                                     # 원하는 태스크 개수
  health_check_grace_period_seconds = each.value.health_check_grace_period_sec                                     # 헬스 체크 그레이스 기간
  task_definition                   = aws_ecs_task_definition.ecs_task_definition[each.value.task_definitions].arn # Task Definition ARN

  # 네트워크 구성 (Private Subnet 사용)
  network_configuration {
    subnets          = var.private_subnet_ids # subnet-xxxx, subnet-xxxx, subnet-xxxx
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = each.value.assign_public_ip
  }

  # ALB와 연동된 Load Balancer 설정
  load_balancer {
    target_group_arn = lookup(var.alb_tg_arn, each.key, null)
    container_name   = each.value.container_name
    container_port   = each.value.container_port
  }

  # 배포 회로 차단기 및 롤백
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # 배포 컨트롤러 설정
  deployment_controller {
    type = each.value.deployment_controller
  }

  lifecycle {
    # prevent_destroy = true # Terraform 리소스 삭제 방지
    create_before_destroy = true # 리소스 삭제 되기 전 생성 후 삭제 진행
  }

  # ECS Service는 Cluster, TD, 보안그룹이 생성된 이후에 생성 되어야 함
  depends_on = [
    aws_ecs_cluster.ecs_cluster,
    aws_ecs_task_definition.ecs_task_definition,
    aws_security_group.ecs_security_group
  ]

  tags = merge(var.tags, {
    Name = "${each.value.service_name}-${each.value.env}"
  })
}

# ECS Service에 Attachment 되는 보안그룹 생성
resource "aws_security_group" "ecs_security_group" {
  name        = var.ecs_security_group
  description = "Allow ECS Task inbound traffic and outbound traffic"
  vpc_id      = var.vpc_id # 보안그룹을 생성할 VPC 위치 지정

  lifecycle {
    create_before_destroy = true # 리소스 삭제 되기 전 생성 후 삭제 진행
  }

  tags = merge(var.tags, {
    Name = "${var.ecs_security_group}-${var.env}"
  })
}

resource "aws_security_group_rule" "ecs_ingress_security_group" {
  for_each = local.ecs_security_group_rules.ingress_rules

  description       = "Allow ecs service to receive traffic from Public ALB"
  security_group_id = aws_security_group.ecs_security_group.id
  type              = each.value.type
  from_port         = each.value.from_port # 포트 시작 허용 범위
  to_port           = each.value.to_port   # 포트 종료 허용 범위
  protocol          = each.value.ip_protocol

  # 조건적으로 참조된 보안 그룹 또는 CIDR 블록 사용
  source_security_group_id = try(each.value.referenced_security_group_id, null)
  cidr_blocks              = try([each.value.cidr_ipv4], null)

  lifecycle {
    create_before_destroy = true
  }
}
