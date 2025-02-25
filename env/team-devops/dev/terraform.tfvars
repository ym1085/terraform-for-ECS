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
aws_account = "863518443396"
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
public_subnet_ids = []

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
ecs_container_image_version = "1.0.0"

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
        image     = "863518443396.dkr.ecr.ap-northeast-2.amazonaws.com/core-search-api-server"
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
        image         = "863518443396.dkr.ecr.ap-northeast-2.amazonaws.com/core-filebeat"
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
    service_name                  = "core-search-service",    # 서비스 이름
    desired_count                 = 1,                        # Task 개수
    container_name                = "core-search-api-server", # 컨테이너 이름
    container_port                = 8080,                     # 컨테이너 포트
    task_definitions              = "core-search-td"          # 테스크 지정
    env                           = "stg"                     # ECS Service 환경변수
    health_check_grace_period_sec = 120                       # 헬스 체크 그레이스 기간
    assign_public_ip              = true                      # 우선 public zone에 구성
    target_group_arn              = "terraform-ecs-search-tg" # 연결되어야 하는 Target Group 지정
  },
}

# ECS Autoscaling
ecs_appautoscaling_target = {
  "core-search-service" = {
    min_capacity          = 2                                                         # 최소 Task 2개가 항상 실행되도록 설정
    max_capacity          = 6                                                         # 최대 Task 6개까지 증가 할 수 있도록 설정
    resource_id           = "service/core-search-cluster-stg/core-search-service-stg" # TODO: 하드코딩된 부분 수정 -> AG를 적용할 대상 리소스 지정, 여기서는 ECS 서비스 ARN 형식의 일부 기재
    scalable_dimension    = "ecs:service:DesiredCount"                                # 조정할 수 있는 AWS 리소스의 특정 속성을 지정하는 필드
    service_namespace     = "ecs"
    scale_out_policy_name = "core-search-service-scaleout-policy" # ScaleOut AG 정책 이름 명시
    scale_in_policy_name  = "core-search-service-scale-in-policy" # ScaleIn AG 정책 이름 명시
    cluster_name          = "core-search-cluster"                 # ECS 클러스터명 지정
    service_name          = "core-search-service"                 # ECS 서비스명 지정
  },
}

# ECS Autoscaling 정책
ecs_appautoscaling_target_policy = {
  "core-search-service" = {
    scale_out = {
      name        = "core-search-service-scaleout-policy" # 스케일 아웃 정책명
      policy_type = "StepScaling"                         # 정책 타입
      step_scaling_policy_conf = {
        adjustment_type         = "ChangeInCapacity" # 조정 방식 (퍼센트 증가: PercentChangeInCapacity, 개수: ChangeInCapacity)  
        cooldown                = 60                 # Autoscaling 이벤트 후 다음 이벤트까지 대기 시간(60초)
        metric_aggregation_type = "Average"          # 측정 지표의 집계 방식 (AVG: 평균)
        step_adjustment = {
          # Threshold 30 -> CPU 30 - 40% 스케일링
          "between_than_10_and_20" = {
            metric_interval_lower_bound = 0  # 트리거 조건의 최소 임계값(0%)
            metric_interval_upper_bound = 10 # 트리거 조건의 최대 임계값(10%)
            scaling_adjustment          = 1  # 조정 비율 (50% 비율로 ECS Task 증가 or 개수도 지정 가능)
          },
          # Threshold 30 -> CPU 40 - 50% 스케일링
          "between_than_20_and_30" = {
            metric_interval_lower_bound = 10
            metric_interval_upper_bound = 20
            scaling_adjustment          = 2
          },
          # Threshold 30 -> CPU 50 - n 스케일링
          "between_than_30_and_40" = {
            metric_interval_lower_bound = 20
            scaling_adjustment          = 3 # 3개의 Task 증설
          },
        }
      }
    },
  }
}

# ECS Autoscaling Cloudwatch policy
ecs_cpu_scale_out_alert = {
  "core-search-service" = {
    alarm_name          = "core-search-service-scalout-cpu-alert"
    comparison_operator = "GreaterThanOrEqualToThreshold" # 메트릭이 임계값보다 크거나 같으면 발동
    evaluation_periods  = "1"                             # 평가 주기는 1번 -> 1번만 조건에 맞아도 이벤트 발생
    metric_name         = "CPUUtilization"                # 메트릭 이름은 ECS의 CPU 사용률
    namespace           = "AWS/ECS"                       # 메트릭이 속한 네임스페이스
    period              = "60"                            # 60초마다 평가 
    statistic           = "Average"                       # 집계 방식은 평균으로
    threshold           = "30"                            # 30부터 스케일링 진행
    dimensions = {
      cluster_name = "core-search-cluster"
      service_name = "core-search-service"
    }
    env = "stg"
  }
}

################
# EC2 설정
################
# EC2 보안그룹 설정
ec2_security_group = {
  "terraform-atlantis-sg" = [
    {
      ec2_security_group_name        = "terraform-atlantis-sg"
      ec2_security_group_description = "Security group for ec2 with terraform atlantis"
      env                            = "stg"
    },
  ],
}

# EC2 보안그룹 규칙 설정
ec2_security_group_ingress_rules = {
  "terraform-atlantis-sg-ingress-rule" = [
    {
      ec2_security_group_name = "terraform-atlantis-sg" # 참조하는 보안그룹 이름을 넣어야 each.key로 구분 가능
      type                    = "ingress"
      description             = "EC2 atlantis Github web hook & Desktop enter"
      from_port               = 4141
      to_port                 = 4141
      protocol                = "tcp"
      cidr_ipv4 = [
        "192.30.252.0/22",
        "185.199.108.0/22",
        "140.82.112.0/20",
        "39.118.148.0/24"
      ]
      source_security_group_id = null
      env                      = "stg"
    },
    {
      ec2_security_group_name = "terraform-atlantis-sg"
      description             = "EC2 atlantis ssh enter"
      type                    = "ingress"
      from_port               = 22
      to_port                 = 22
      protocol                = "tcp"
      cidr_ipv4 = [
        "39.118.148.0/24"
      ]
      source_security_group_id = null
      env                      = "stg"
    }
  ]
}

ec2_security_group_egress_rules = {
  "terraform-atlantis-sg-egress-rule" = [
    {
      ec2_security_group_name  = "terraform-atlantis-sg"
      description              = "Allow all outbound traffic"
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"          # 모든 프로토콜 허용
      cidr_ipv4                = ["0.0.0.0/0"] # 모든 IP로 트래픽 허용
      source_security_group_id = null
      env                      = "stg"
    }
  ]
}

# 생성을 원하는 N개의 EC2 정보 입력 -> EC2 성격별로 나누면 될 듯(Elasticsearch, Atlantis.. 등등)
ec2_instance = {
  "ec2_atlantis" = { # GitOps Atlantis
    create = false

    # SSH key pair
    key_pair_name         = "atlantis-ec2-key"
    key_pair_algorithm    = "RSA"
    rsa_bits              = 4096
    local_file_name       = "keypair/atlantis-ec2-key.pem" # terraform key pair 생성 후 저장 경로 modules/aws/compute/ec2/...
    local_file_permission = "0600"                         # 6(read + writer)00

    # ECS Option
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    disable_api_termination     = true
    ec2_instance_name           = "atlantis-ec2"
    ec2_security_group_name     = "atlantis-sg"
    env                         = "stg"
  },
  "ec2_jenkins" = { # Jenkins on EC2
    create = true # EC2 인스턴스 생성 여부 지정

    key_pair_name         = "jenkins-ec2-key"
    key_pair_algorithm    = "RSA"
    rsa_bits              = 4096
    local_file_name       = "keypair/jenkins-ec2-key.pem" # terraform key pair 생성 후 저장 경로 modules/aws/compute/ec2/...
    local_file_permission = "0600"                        # 6(read + writer)00

    # ECS Option
    instance_type               = "t2.micro"    # EC2 인스턴스 타입 지정
    associate_public_ip_address = true          # EC2 퍼블릭 IP 자동 할당 여부 지정
    disable_api_termination     = true          # API 기반 EC2 삭제 disabled
    ec2_instance_name           = "jenkins-ec2" # EC2 인스턴스명
    ec2_security_group_name     = "jenkins-sg"  # EC2 인스턴스 보안그룹명
    env                         = "stg"
  }
}

################
# S3 설정
################
s3_bucket = {
  terraform_state = {
    bucket_name = "terraform-s3-ymkim-state"
  },
}

################
# CICD 설정
################
code_commit = {
  "core-search-repository" = {
    repository_name = "core-search"
    description     = "AWS Codecommit Repository for ecs core api server"
    default_branch  = "master"
    env             = "stg"
  }
}

################
# 공통 태그 설정
################
tags = {
  env       = "stg"
  project   = "terraform-ecs"
  teamTag   = "devops"
  managedBy = "terraform"
  createdBy = "devops-admin@gmail.com"
}
