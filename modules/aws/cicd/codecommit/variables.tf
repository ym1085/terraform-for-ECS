####################
# 프로젝트 기본 설정
####################
# AWS 개발 환경
variable "env" {
  description = "AWS 개발 환경 설정"
  type        = string
}

################
# CICD 설정
################
variable "code_commit" {
  description = "Codecommit 관련 정보 기재"
  type = map(object({
    repository_name = string
    description     = string
    default_branch  = string
    env             = string
  }))
}

####################
# 공통 태그 설정
####################
variable "tags" {
  description = "공통 태그 설정"
  type        = map(string)
}
