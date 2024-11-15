locals {
  vpc_id = "vpc-08d6714982a88042e" # search-recommend-prod-vpc-172.21.0.0/16

  core_alb_public_subnets = [
    "subnet-0e001c3dab9d9d300", # az-a
    "subnet-006d2bdf594c00c95", # az-b
    "subnet-0df389f91795163f9"  # az-c
  ]

  core_alb_sg_id = "sg-05d501feb454166de"
  core_alb_tg = {
    "search-api" = {
      type     = "alb"
      category = "app"
      port     = 10091
      api_type = "search"
    },
    "meta-api" = {
      type     = "alb"
      category = "app"
      port     = 10092
      api_type = "meta"
    },
    "user-api" = {
      type     = "alb"
      category = "app"
      port     = 10093
      api_type = "user"
    },
    "curation-api" = {
      type     = "alb"
      category = "app"
      port     = 10094
      api_type = "curation"
    }
  }
}

module "alb" {
  source = "../../modules/aws/alb"

  vpc_id                  = local.vpc_id                  #TODO
  core_alb_public_subnets = local.core_alb_public_subnets #TODO
  core_alb_sg_id          = local.core_alb_sg_id          #TODO
  core_alb_tg             = local.core_alb_tg             #TODO

}
