# 기본 VPC가 존재하는 경우, data 구문을 통해 VPC 참조
# data "aws_vpc" "vpc" {
#   filter {
#     name   = "tag:Name"      # 필터링 조건은 VPC명
#     values = ["default-vpc"] # 이미 생성되어 있는 VPC의 이름을 기반으로 VPC ID 조회
#   }
# }

module "network" {
  source = "../../modules/aws/network"

  vpc_cidr             = var.vpc_cidr             # IPV4 CIDR Block(172.22.0.0/16)
  enable_dns_support   = var.enable_dns_support   # DNS Hostname 사용 옵션, 기본 false(VPC 내 리소스가 AWS DNS 주소 사용 가능)
  enable_dns_hostnames = var.enable_dns_hostnames # DNS Hostname 사용 옵션, 기본 true(VPC 내 DNS 호스트 이름 사용)
  public_subnets_cidr  = var.public_subnets_cidr  # 퍼블릭 서브넷 목록(172.x.x.x/24, 172.x.x.x/24)
  private_subnets_cidr = var.private_subnets_cidr # 프라이빗 서브넷 목록(172.x.x.x/24, 172.x.x.x/24)
  availability_zones   = var.availability_zones   # 가용영역

  # 프로젝트 기본 설정
  project_name = var.project_name # 프로젝트명
  env          = var.env          # 개발 환경 변수
  tags         = var.tags         # 공통 태그
}

module "load_balancer" {
  source = "../../modules/aws/load_balancer"

  # 로드밸런서 관련 설정
  alb               = var.alb               # 생성을 원하는 ALB 관련 정보
  alb_listener      = var.alb_listener      # 위에서 생성한 ALB Listener 관련 정보
  alb_listener_rule = var.alb_listener_rule # ALB Listener Rule
  target_group      = var.target_group      # ALB의 Target Group

  # 프로젝트 기본 설정
  tags   = var.tags
  vpc_id = module.network.vpc_id
}

module "ecr" {
  source = "../../modules/aws/ecr"

  # ECR 관련 설정
  ecr_repository = var.ecr_repository

  # 프로젝트 기본 설정
  tags = var.tags
}

module "compute" {
  source = "../../modules/aws/compute/ecs"

  # 네트워크 설정
  public_subnet_ids    = var.public_subnet_ids
  private_subnet_ids   = var.private_subnet_ids
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr

  # ECS 관련 설정
  ecs_cluster          = var.ecs_cluster
  ecs_task_definitions = var.ecs_task_definitions
  ecs_service          = var.ecs_service

  # ECS Service에서 ELB 연동 시 사용
  alb_tg_arn       = module.load_balancer.alb_target_group_arn
  alb_listener_arn = module.load_balancer.alb_listener_arn

  # 프로젝트 기본 설정
  aws_region  = var.aws_region
  aws_account = var.aws_account
  env         = var.env
  tags        = var.tags

  # ELB가 생성 된 후 ECS 생성 가능
  depends_on = [module.load_balancer]
}
