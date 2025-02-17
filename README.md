# Terraform ECS

## Overview

이 프로젝트는 Terraform을 통해 AWS ECS를 설정하고 관리하기 위한 목적의 리포지토리입니다.  
배포 파이프라인의 경우 AWS Code Series를 사용하여, 자동화된 인프라 관리를 수행하려고 합니다.

## Tech Spec

| Component                     | Version |
| ----------------------------- | ------- |
| Terraform                     | v1.9.7  |
| Provider (hashicorp/aws)      | v4.67.0 |
| Provider (hashicorp/random)   | v3.6.3  |
| Provider (hashicorp/template) | v2.2.0  |

**Note:** Your version of Terraform is out of date! The latest version is **v1.10.4**.  
You can update by downloading from [Terraform Downloads](https://www.terraform.io/downloads.html).

## Usage

```shell
cd env/dev
```

- [env/dev/terraform.tfvars](./env/dev/terraform.tfvars) 파일 확인
- aws_account 및 ecs_task_definitions.containers.image 변수를 본인의 AWS 계정으로 변경

```shell
terraform init
```

- terraform resource 초기화

```shell
terraform fmt
terraform validate
```

- terraform format, validation 검사

```shell
terraform plan
```

- terraform resource 실행 계획 확인
- image_version : ECS Container 이미지 버전 입력

```shell
# terraform 리소스 생성
terraform apply
```

## Visualization With Pluralith

### Download Pluralith CLI

> [Pluralith Docs](https://docs.pluralith.com/docs/get-started/run-locally)

- Pluralith 사용을 위해 `Pluralith CLI` 설치 페이지로 이동 후 다운로드

### Pluralith Login

```shell
pluralith login --api-key $PLURALITH_API_KEY
```

- pluralith login 수행

```shell
export TF_VAR_ecs_container_image_version=1.0.0
```

- ECS Image Version 환경 변수 설정

### Pluralith Graph

```shell
pluralith graph
```

- pluralith graph 실행