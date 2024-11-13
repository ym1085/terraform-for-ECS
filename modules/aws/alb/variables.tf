# ALB Public Subnet 목록
# Inject variables : o
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# ALB 퍼블릭 서브넷 목록
# Inject variables : x
variable "core_alb_public_subnets" {
  type        = list(string)
  description = "ALB 퍼블릭 서브넷 목록"
  default = [
    "subnet-0e001c3dab9d9d300",
    "subnet-006d2bdf594c00c95",
    "subnet-0df389f91795163f9"
  ]
}

# ALB SG ID
# Inject variables : o
variable "core_alb_sg_id" {
  type        = string
  description = "검색 ALB SG ID"
}

# META TG 목록
# Inject variables : x
variable "core_alb_tg" {
  type = map(object({
    type     = string
    category = string
    port     = number
    api_type = string
  }))
  default = {
    "search-api" = {
      type     = "alb",
      category = "app",
      port     = 10091,
      api_type = "search"
    },
    "meta-api" = {
      type     = "alb",
      category = "app",
      port     = 10092,
      api_type = "meta"
    },
    "user-api" = {
      type     = "alb",
      category = "app",
      port     = 10093,
      api_type = "user"
    },
    "curation-api" = {
      type     = "alb",
      category = "app",
      port     = 10094,
      api_type = "curation"
    }
  }
}
