# AWS ECS CI/CD with Terraform

Terraform을 활용해 AWS ECS와 CI/CD 파이프라인을 구축하기 위한 리포지토리 입니다.

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

## Installation & Setup

```shell
# enter your aws account on local
$ aws configure
AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: ap-northeast-2
Default output format [None]: json
```

```shell
# check aws account info
$ aws sts get-caller-identity
{
    "UserId": "AIDXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/YourUserName"
}
```

```shell
# move to /env/dev folder
cd env/dev
```

```shell
# initialize terraform project
$ terraform init
```

```shell
# validate terraform file
$ terraform validate
```

```shell
# check terraform plan
$ terraform plan
```

```shell
# apply & deploy terraform resource
$ terraform apply
```

```shell
# destory all terraform resource
$ terraform destroy
```