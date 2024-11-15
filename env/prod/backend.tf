# terraform {
#   backend "s3" {
#     bucket         = "search-terraform-state-bucket"      # s3 버킷명
#     key            = "terraform/search/terraform.tfstate" # state 파일 s3 저장 경로
#     region         = "ap-northeast-2"                     # s3 리전
#     encrypt        = true                                 # terraform.state 파일 암호화 지정 여부
#     dynamodb_table = "tfstate-lock"                       # DynamoDB 테이블명, DynamoDB 테이블을 사용한 잠금 기능(동시성 제어)
#   }
# }