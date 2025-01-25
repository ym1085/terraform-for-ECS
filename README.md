# Terraform ECS

## Overview

이 프로젝트는 Terraform을 통해 AWS ECS(Elastic Container Service)를 설정하고 관리하기 위한 목적의 리포지토리입니다.  
CI/CD의 경우 AWS Code Series를 사용하여, 자동화된 인프라 관리를 수행하려고 합니다.

## Tech Spec

| Component                     | Version |
| ----------------------------- | ------- |
| Terraform                     | v1.9.7  |
| Provider (hashicorp/aws)      | v4.67.0 |
| Provider (hashicorp/random)   | v3.6.3  |
| Provider (hashicorp/template) | v2.2.0  |

**Note:** Your version of Terraform is out of date! The latest version is **v1.10.4**.  
You can update by downloading from [Terraform Downloads](https://www.terraform.io/downloads.html).

## Project Structure

```shell
terraform-for-ECS
├── env/
│   ├── dev/
│   ├── prod/
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
│   │   ├── load_balancer/
│   │   ├── network/
│   │   ├── security/
│   │   ├── storage/
├── .gitignore
└── README.md
```

## How to use this project?

✅ Terraform 실행은 로컬에 Terraform이 설치되어 있다는 전제하에 진행됩니다.
설치가 필요할 경우, 상단의 다운로드 페이지를 참고해주세요.

```shell
# 루트 모듈 이동
cd env/dev
```

- [env/dev/terraform.tfvars](./env/dev/terraform.tfvars) 파일 확인
- 해당 파일의 `aws_account`, `ecs_task_definitions.containers.image` 변수 값을 본인 AWS 계정의 account로 변경

```shell
# terraform provider, 모듈, 기타 환경 초기화
terraform init
```

```shell
# terraform 포맷 체크
terraform fmt

# terraform 구문 유효성 검증
terraform validate
```

```shell
# terraform plan
terraform plan   
var.ecs_container_image_version
  ECS Container의 이미지 버전 <input image version>

  Enter a value: <생성하고자 하는 ECS Task container의 이미지 버전 입력>
```

```shell
# terraform 리소스 생성
terraform apply
```

## Terraform Visualization With Pluralith

### 01. Download Pluralith CLI

> [🗂️ Run Pluralith Locally](https://docs.pluralith.com/docs/get-started/run-locally)

- Pluralith CLI 설치

### 02. Pluralith Login

- pluralith login 수행

```shell
# Pluralith Account Settings의 API KEY를 아래 Login 커멘드 실행 시 변수로 넘긴다
$ pluralith login --api-key $PLURALITH_API_KEY

parsing response failed -> GetGitHubRelease: %!w(<nil>)
 _
|_)|    _ _ |._|_|_ 
|  ||_|| (_||| | | |

Welcome to Pluralith!

  ✔ API key is valid, you are authenticated! # API KEY 유효성 이상 x
```

```shell
# ecs container image의 경우 환경변수로 빼둔다
export TF_VAR_ecs_container_image_version=1.0.0
```

### 03. Pluralith Graph

- pluralith graph 수행

```shell
$ pluralith graph

parsing response failed -> GetGitHubRelease: %!w(<nil>)
⠿ Initiating Graph ⇢ Posting Diagram To Pluralith Dashboard

→ Authentication
  ✔ API key is valid, you are authenticated!

→ Plan
  ✔ Local Execution Plan Generated  
  ✔ Local Plan Cache Created  
  ✔ Secrets Stripped  
  - Cost Calculation Skipped

→ Graph
  ✔ Local Diagram Generated  
  ✔ Diagram Posted To Pluralith Dashboard

  → Diagram Pushed To: https://app.pluralith.com/#/orgs/3xxxxxxxxxxx/projects/pluralith-local-project/runs/40xxxxxxxxxxx/
```