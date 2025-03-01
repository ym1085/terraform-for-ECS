# Terraform ECS

## Overview

이 프로젝트는 Terraform을 사용하여 AWS ECS를 설정하고 관리하기 위한 리포지토리입니다.  
배포 파이프라인은 AWS Code Series를 활용하여 자동화된 인프라 관리를 수행합니다.

## Tech Spec

> 최신 버전은 [Terraform Downloads](https://www.terraform.io/downloads.html)에서 받을 수 있습니다.

| Component                     | Version |
| ----------------------------- | ------- |
| Terraform                     | v1.9.7  |
| Provider (hashicorp/aws)      | v4.67.0 |
| Provider (hashicorp/random)   | v3.6.3  |
| Provider (hashicorp/template) | v2.2.0  |

## Usage

GitOps 환경에서 Terraform으로 생성된 EC2 서버에 Atlantis를 Docker 컨테이너를 구동합니다.
Github PR이 생성되면, Github Webhook을 통해 EC2에서 실행 중인 Atlantis로 요청을 보내고 명령을 수행합니다.
Terraform을 통해 EC2가 생성되면, 해당 서버에 접속하여 AWS 자격 증명을 등록해야 합니다.
등록된 자격 증명은 Docker 컨테이너에 마운트하여 지속적으로 유지됩니다.

### Edit init_atlantis.sh

```shell
# EC2 초기 설정 스크립트 수정
vi modules/aws/compute/ec2/script/init_atlantis.sh
```

Terraform을 사용하여 EC2 인스턴스 생성 후 Docker 컨테이너로 Atlantis를 구동 하도록 되어 있습니다.
하여, Github의 `USERNAME`, `Token`, `Repo URL`은 보안상 직접 노출이 불가능하기에 본인 계정 정보를 기재해야 합니다.
`Atlantis EC2 & Github Webhook 셋팅` 관련 내용은 [다음 링크](https://okms1017.tistory.com/70)를 참고 부탁드리겠습니다.

```shell
#!/bin/bash
set -e

##############################
# 1. 시스템 설정 및 기본 패키지 설치
##############################
# 호스트명 설정
sudo hostnamectl --static set-hostname Atlantis

..중략

# Docker Atlantis 실행
docker run -itd \
-p 4141:4141 \
--name atlantis \
-v /home/ec2-user/.aws:/root/.aws:ro \
atlantis server \
--automerge \
--autoplan-modules \
--gh-user=<github_user_name> \
--gh-token=<github_token> \
--repo-allowlist=<github_repository_url>
```

### Atlantis Settings

> 해당 리포지토리를 Fork하여 사용하는 것을 권장합니다.

- EC2 인스턴스에서 Atlantis 컨테이너 실행을 위한 설정 정보:
  - **GitHub 사용자명**: `<github_user_name>`
  - **GitHub 토큰**: `<github_token>`
  - **GitHub 리포지토리 URL**: `<github_repository_url>`

### Run Terraform

```shell
# Terraform root 모듈로 이동
cd env/team-devops/dev
```

```shell
# env/team-devops/dev
# aws_account 변경
aws_account = "8xxxxxxxxx"

# container image account 변경
image     = "8xxxxxxxxx.dkr.ecr.ap-northeast-2.amazonaws.com/core-search-api-server"
```

- [terraform.tfvars](./env/team-devops/dev/terraform.tfvars) 파일의 `aws_account` 변수를 본인의 AWS account으로 변경

```shell
#terraform init
#terraform fmt
#terraform validate
#terraform plan

# terraform 실행
chmod +x run_terraform.sh
./run_terraform.sh
```

```shell
# terraform 리소스 생성
terraform apply
```

## Visualization With Pluralith

- [Pluralith CLI](https://docs.pluralith.com/docs/get-started/run-locally) 설치 페이지 이동 후 다운로드

```shell
pluralith login --api-key $PLURALITH_API_KEY
```

- pluralith 로그인

```shell
pluralith graph
```

- pluralith 리소스 시각화