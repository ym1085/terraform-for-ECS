# export TF_VAR_ecs_container_image_version="1.0.0"
# pluralith graph

####################
# 프로젝트 기본 설정
####################
project_name = "terraform-ecs"
aws_region   = "ap-northeast-2"
availability_zones = [
  "ap-northeast-2a",
  "ap-northeast-2b"
]
aws_account = "8xxxxxxxxxxx" # IAM USER: terraform-admin
env         = "stg"

####################
# 네트워크 설정
####################
# IP 대역
# 10.0.0.0 - 10.255.255.255		-> 		16,777,216
# 172.16.0.0 - 172.31.255.255		-> 		1,048,576
# 192.168.0.0 - 192.168.255.255	->		65,536
# VPC ID(외부 data 변수를 통해 받음, 초기에는 빈값으로 셋팅)
vpc_id = ""

# VPC CIDR 대역 지정 - VPC CIDR는 개발환경에 적합한 크기로 설정
vpc_cidr = "172.22.0.0/16"

# 각 가용영역마다 하나의 public/private 서브넷 -> 가용 영역은 현재 2개
# 퍼블릭 서브넷 지정 -> 서브넷 당 256개 IP 사용 가능(5개는 빼야함)
# /24 -> 앞의 3개의 IP가 네트워크 주소, 나머지 8비트가 호스트 비트
public_subnets_cidr = [
  "172.22.10.0/24",
  "172.22.11.0/24"
]

# 프라이빗 서브넷 지정
private_subnets_cidr = [
  "172.22.20.0/24",
  "172.22.21.0/24"
]

# 퍼블릭 서브넷 ID 지정
# public_subnet_ids = [
#   "subnet-xxxxxxxx",
#   "subnet-xxxxxxxx"
# ]

# 프라이빗 서브넷 ID 지정
# private_subnet_ids = [
#   "subnet-xxxxxxxx",
#   "subnet-xxxxxxxx"
# ]

# DNS Hostname 사용 옵션, 기본 false(VPC 내 리소스가 AWS DNS 주소 사용 가능)
# DNS 기능 자체를 켤지 말지 정하는 옵션, 키는 경우 VPC에서 DNS 기능 사용 가능
# 활성화 : DNS -> IP / IP -> DNS
# 비활성화 : IP로만 통신 가능
enable_dns_support = true

# DNS 이름을 만들지 말지 정하는 옵션, 이것도 켜야 실제 VPC 내의 리소스들이 DNS로 통신이 가능할 듯
enable_dns_hostnames = true

####################
# 로드밸런서 설정
####################
# ALB 생성
# -> ALB의 KEY 이름과, Target Group 변수의 KEY 이름을 일치시켜야 함
alb = {
  "terraform-ecs-alb" = {
    alb_name                             = "terraform-ecs-alb"
    alb_internal                         = false
    alb_load_balancer_type               = "application"
    alb_enable_deletion_protection       = false # 생성하고 난 후에 true로 변경
    alb_enable_cross_zone_load_balancing = true
    alb_idle_timeout                     = 300
    env                                  = "stg"
  }
}

# ALB 보안그룹 생성
alb_security_group = "terraform-ecs-alb-sg"

# ALB Listencer 생성
alb_listener = {
  "terraform-ecs-alb-http-listener" = {
    name              = "terraform-ecs-alb-http-listener"
    port              = 80
    protocol          = "HTTP"
    load_balancer_arn = "terraform-ecs-alb" # 연결할 ALB 이름 지정
    default_action = {
      type             = "forward" # forward, redirect(다른 URL 전환), fixed-response(고정 응답값)
      target_group_arn = "terraform-ecs-search-tg"
    }
    env = "stg"
  },
}

# ALB Listener Rule 생성
alb_listener_rule = {
  "terraform-ecs-alb-http-listener-search-rule" = {
    type              = "forward"
    path              = ["/api/v1/*", "/search/*"]
    alb_listener_name = "terraform-ecs-alb-http-listener"
    target_group_name = "terraform-ecs-search-tg"
    priority          = 1
  },
}

# ALB Target Group 생성
target_group = {
  "terraform-ecs-search-tg" = {
    target_group_name        = "terraform-ecs-search-tg"
    target_group_port        = 8080
    target_group_elb_type    = "ALB"
    target_group_target_type = "ip" # FARGATE는 IP로 지정해야 함, 동적으로 IP(ENI) 할당됨
    env                      = "stg"
    health_check = {
      enabled             = true
      healthy_threshold   = 3
      interval            = 30
      port                = 8080
      protocol            = "HTTP"
      timeout             = 15
      unhealthy_threshold = 5
      internal            = false
    }
    enabled = true # health_check 바깥에 위치해야 함
  },
}

####################
# ECR 설정
####################
# ECR 리포지토리 생성
ecr_repository = {
  "core-search-api-server" : {
    ecr_repository_name      = "core-search-api-server" # 리포지토리명
    env                      = "stg"                    # ECR 개발환경
    ecr_image_tag_mutability = "IMMUTABLE"              # image 버전 고유하게 관리할지 여부
    ecr_scan_on_push         = false                    # PUSH Scan 여부
    ecr_force_delete         = false
  },
  "core-filebeat" = {
    ecr_repository_name      = "core-filebeat" # 리포지토리명
    env                      = "stg"           # ECR 개발환경
    ecr_image_tag_mutability = "IMMUTABLE"     # image 버전 고유하게 관리할지 여부
    ecr_scan_on_push         = false           # PUSH Scan 여부
    ecr_force_delete         = false
  },
}

####################
# ECS 클러스터 설정
####################
# ECS 클러스터 생성
ecs_cluster = {
  "core-search-cluster" = {
    cluster_name = "core-search-cluster"
    env          = "stg"
  },
}

# ECS Security Group 
# -> ecs_service 변수에 n개를 넣는건 이미 보안그룹이 존재하는 경우만 그렇게 사용 가능
ecs_security_group = "core-search-ecs-sg"

# ECS IAM Role
ecs_task_role               = "ecs_task_role"
ecs_task_role_policy        = "custom_ecs_task_role_policy"
ecs_task_exec_role          = "ecs_task_exec_role"
ecs_task_exec_role_policy   = "custom_ecs_task_exec_role_policy"
ecs_auto_scaling_role       = "ecs_auto_scaling_role"
ecs_auto_scaling_policy_arn = "AmazonEC2ContainerServiceAutoscaleRole" # 기존에 생성되어 있는 정책을 참조

# ECS Container Image 버전
# ecs_container_image_version = ""

# ECS Task Definitions 생성
# TODO: containers.env 추가? + image_version 어떻게 받을지?
ecs_task_definitions = {
  "core-search-td" = {
    name                                    = "core-search-td"
    task_role                               = "ecs_task_role"
    task_exec_role                          = "ecs_task_exec_role"
    network_mode                            = "awsvpc"
    launch_type                             = "FARGATE"
    task_total_cpu                          = 1024 # ECS Task Total CPU
    task_total_memory                       = 2048 # ECS Task Total Mem
    runtime_platform_oprating_system_family = "LINUX"
    runtime_platform_cpu_architecture       = "X86_64"
    task_family                             = "core-search-td"
    cpu                                     = 1024
    memory                                  = 2048
    env                                     = "stg"
    ephemeral_storage                       = 21
    containers = [
      {
        name      = "core-search-api-server"
        image     = "8xxxxxxxxxxx.dkr.ecr.ap-northeast-2.amazonaws.com/core-search-api-server"
        version   = "latest" # container image version은 ecs_container_image_version 변수 사용
        cpu       = 512      # container cpu
        memory    = 1024     # container mem
        port      = 8080
        essential = true
        env_variables = {
          "TZ"                     = "Asia/Seoul"
          "SPRING_PROFILES_ACTIVE" = "stg"
        }
        mount_points = []
        health_check = {
          command  = "curl --fail http://127.0.0.1:8080/search/health || exit 1"
          interval = 30
          timeout  = 10
          retries  = 3
        },
        env = "stg"
      },
      {
        name          = "core-filebeat"
        image         = "8xxxxxxxxxxx.dkr.ecr.ap-northeast-2.amazonaws.com/core-filebeat"
        version       = "latest" # container image version은 ecs_container_image_version 변수 사용
        cpu           = 256      # container cpu
        memory        = 512      # container mem
        port          = 0
        essential     = true
        env_variables = {}
        mount_points  = []
        health_check = {
          command  = "ps aux | grep filebeat || exit 1"
          interval = 30
          timeout  = 10
          retries  = 3
        },
        env = "stg"
      }
    ]
  },
}

# ECS 서비스 생성
ecs_service = {
  "core-search-service" = {
    launch_type                   = "FARGATE"
    service_role                  = "AWSServiceRoleForECS"
    deployment_controller         = "ECS"
    cluster_name                  = "core-search-cluster"
    service_name                  = "core-search-service",        # 서비스 이름
    desired_count                 = 1,                            # Task 개수
    container_name                = "core-search-api-server-stg", # 컨테이너 이름
    container_port                = 8080,                         # 컨테이너 포트
    task_definitions              = "core-search-td"              # 테스크 지정
    env                           = "stg"
    health_check_grace_period_sec = 120  # 헬스 체크 그레이스 기간
    assign_public_ip              = true # 우선 public zone에 구성
  },
}

################
# S3 설정
################
s3_bucket = {
  terraform_state = {
    bucket_name = "terraform-s3-devops-sample-state" # terraform state S3 버킷명
  },
}

################
# 공통 태그 설정
################
tags = {
  env       = "stg"              # 개발 환경명 입력
  project   = "terraform-ecs"    # 프로젝트명 입력
  teamTag   = "devops"           # 팀 태그 입력
  managedBy = "terraform"        # 해당 리소스가 어떤 서비스에 의해 생성이 되는지?(AWS Console, IaC?)
  createdBy = "devops@gmail.com" # 인프라 생성자 혹은 팀의 이메일 계정 입력
}
