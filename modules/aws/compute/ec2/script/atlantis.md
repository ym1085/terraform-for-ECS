# Setting EC2 Atlantis

> Terraform EC2 생성 후 Atlantis 구성

```shell
# Terraform 버전 확인
terraform version

# AWS Configure 등록
aws configure

# Atlantis 버전 확인
./atlatis version

# 깃헙 사용자 이름 지정
USERNAME=ym1085

# 외부 접근 가능한 공인 IP:포트 주소를 URL 변수로 지정
URL="http://$(curl -s ipinfo.io/ip):4141"

# Git Repo & Token 생성 후 환경변수로 지정
TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx

# Webhook에서 사용할 secret 생성 후 환경변수로 지정
# 환경 변수 지정 후 Webhook은 깃헙에서 생성
# https://www.browserling.com/tools/random-string
SECRET=muzsavldrevjnypxypwbsobc

# 허용하는 Github Repo 등록
REPO_ALLOWLIST=https://github.com/ym1085/terraform-for-ECS

# Atlantis 구동
$ echo $URL $USERNAME $TOKEN $SECRET $REPO_ALLOWLIST
$ ./atlantis server \
--atlantis-url="$URL" \
--gh-user="$USERNAME" \
--gh-token="$TOKEN" \
--gh-webhook-secret="$SECRET" \
--repo-allowlist="$REPO_ALLOWLIST"
```