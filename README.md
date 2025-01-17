# Terraform ECS

> Terraform을 활용해 AWS VPC, Subnet, ECS 환경을 구축하기 위한 리포지토리 입니다.

```shell
# Terraform AWS ECS 프로젝트 폴더 구조
terraform-for-ECS
├── env/
│   ├── dev/
│   │   ├── .terraform.lock.hcl
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod/
│
├── modules/
│   ├── aws/
│   │   ├── compute/
│   │   │   ├── ecs/
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   ├── task_definitions.tpl
│   │   │   │   └── variables.tf
│   │   │   ├── eks/
│   │   │   │   ├── main.tf
│   │   │   │   ├── outputs.tf
│   │   │   │   └── variables.tf
│   │   ├── ecr/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── load_balancer/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── network/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── security/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── storage/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│
├── .gitignore
└── README.md
```