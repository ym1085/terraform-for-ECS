# Terraform ECS

> A repository for building AWS VPC, Subnet, and ECS environments using Terraform.

## Project Tech Spec

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

## Terraform Visualization With Pluralith

### 01. Download Pluralith CLI

> [[Pluralith CLI 공식문서] Run Pluralith Locally](https://docs.pluralith.com/docs/get-started/run-locally)

- [Pluralith Github repository](https://github.com/Pluralith/pluralith-cli/releases) 접근 후 OS 맞는 Pluralith CLI 설치
- pluralith_cli_windows_amd64_v0.2.2.exe(window 기준) 파일 다운로드 후 파일 이름을 `pluralith.exe`로 변경
- `C:\Windows\System32\` 경로에 위 파일(`pluralith.exe`) 이동
- pluralith.exe 뿐만 아니라 [pluralith-cli-graphing-release](https://github.com/Pluralith/pluralith-cli-graphing-release/releases) 다운로드
- `C:\Users\{사용자명}\Pluralith\bin\` 경로에 해당 파일(`pluralith-cli-graphing.exe`) 이동

### 02. Pluralith Login

- 1번 과정이 끝나는 경우, pluralith login을 수행
- login이 정상적으로 되는 경우 아래와 같은 결과 반환

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

### 03. Pluralith Graph

- 2번 과정에서 로그인 성공 후 Terraform 리소스의 시각화 진행
- 실행 결과의 Diagram 산출물은 Pluralith Web 상에서 확인 가능

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