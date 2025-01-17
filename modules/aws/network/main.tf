locals {
  project_name = var.project_name               # 프로젝트 이름
  az_count     = length(var.availability_zones) # 가용영역 개수
}

# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr             # IPv4 CIDR Block(172.22.0.0/16)
  enable_dns_hostnames = var.enable_dns_hostnames # DNS hostname을 만들건지 안 만들건지 지정하는 옵션
  enable_dns_support   = var.enable_dns_support   # DNS 사용 옵션, 기본 false(VPC 내 리소스가 AWS DNS 주소 사용 가능)

  tags = merge(var.tags, {
    Name = "${locals.project_name}-vpc"
  })
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public_subnet" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id                      # 위에서 만든 VPC ID 별칭 참조
  cidr_block        = var.public_subnets_cidr[count.index] # IPv4 Public Subnet CIDR Block
  availability_zone = var.availability_zones[count.index]  # 가용영역 지정

  map_public_ip_on_launch = true # 서브넷 내의 인스턴스의 퍼블릭 IP를 자동 할당 여부 지정

  tags = merge(var.tags, {
    Name = "${format("%s-sub-pub-%02d", locals.project_name, count.index + 1)}"
  })
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private_subnet" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    # %: 포맷팅의 시작
    # %s: 문자열 데이터를 삽입하겠다는 의미
    # %02d: 최소 2자리 보장
    Name = "${format("%s-sub-pub-%02d", local.project_name, count.index + 1)}"
  })
}

# 인터넷 게이트웨이 생성(IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${local.project_name}-igw"
  })
}

# NAT 게이트웨이 EIP 생성
# NAT 게이트웨이 생성