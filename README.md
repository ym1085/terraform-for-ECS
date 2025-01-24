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

```shell
cd env/dev
```

```shell
terraform init
terraform validate
terraform plan
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