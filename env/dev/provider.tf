# 프로바이더(벤더) 설정
provider "aws" {
  region = var.aws_region
}

# Terraform 관련 설정
terraform {
  # terraform 버전 설정
  required_version = ">= 1.9.5" # terraform 최소 요구 버전 설정(terraform version >= 1.9.5)

  # 프로바이더 관련 설정
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Hashicorp에서 제공하는 공식 'AWS 프로바이더 설정'
      version = "~> 4.0"        # AWS 프로바이더의 버전 요구사항 지정(4.0 이상, 5.0 미만 (4.x.x))
    }
    random = {
      source  = "hashicorp/random" # Hashicorp에서 제공하는 랜덤 값 생성용 프로바이더
      version = "~> 3.0"
    }
  }
}
