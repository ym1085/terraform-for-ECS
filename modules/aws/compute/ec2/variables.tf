####################
# 프로젝트 기본 설정
####################
variable "env" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
  default     = "stg"
}

####################
# 네트워크 설정
####################
variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

# 퍼블릭 서브넷 ID
variable "public_subnet_ids" {
  description = "퍼블릭 서브넷 대역 ID([subnet-xxxxxxxx, subnet-xxxxxxxx])"
  type        = list(string)
}

################
# EC2 설정
################
# EC2 보안그룹 설정
variable "ec2_security_group" {
  description = "EC2 보안그룹 생성"
  type = map(list(object({
    ec2_security_group_name        = optional(string)
    ec2_security_group_description = optional(string)
    env                            = optional(string)
  })))
}

# EC2 보안그룹 규칙 설정
variable "ec2_security_group_rules" {
  description = "EC2 보안그룹 규칙 생성"
  type = map(list(object({
    ec2_security_group_name  = optional(string)       # 참조하는 보안그룹 이름 지정
    description              = optional(string)       # 보안그룹 규칙 설명
    type                     = optional(string)       # ingress, egress
    from_port                = optional(number)       # 포트 시작 범위
    to_port                  = optional(number)       # 포트 종료 범위
    protocol                 = optional(string)       # 프로토콜
    cidr_ipv4                = optional(list(string)) # 허용할 IP CIDR 대역 범위
    source_security_group_id = optional(string)       # 보안그룹을 참조하는 경우 사용
  })))
}

# EC2 생성
variable "ec2_instance" {
  description = "EC2 생성 정보 입력"
  type = map(object({
    # SSH key pair
    key_pair_name         = string
    key_pair_algorithm    = string
    rsa_bits              = number
    local_file_name       = string
    local_file_permission = string

    # ECS Option
    instance_type               = string
    associate_public_ip_address = bool
    disable_api_termination     = bool
    ec2_instance_name           = string
    ec2_security_group_name     = string
    env                         = string
  }))
}

####################
# 공통 태그 설정
####################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
