#!/bin/bash
# 스크립트 오류 발생 시 즉시 스크립트 종료
set -e

##############################
# 1. 시스템 설정 및 기본 패키지 설치
##############################
# 호스트명 설정
sudo hostnamectl --static set-hostname Atlantis

# alias 설정 및 bashrc 수정
echo 'alias vi=vim' | sudo tee -a /etc/profile

# 필수 패키지 설치
sudo yum update -y
sudo yum search docker -y
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
sudo yum install -y yum-utils unzip jq tree zip curl wget
# https://technote.kr/369
sudo usermod -a -G docker $USER

##############################
# 2. Terraform 설치
##############################
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform

# 설치 확인
terraform -version

##############################
# 2. AWS CLI v2 설치
##############################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# 설치 확인
aws --version

##############################
# 3. Atlantis 설치
##############################
# wget https://github.com/runatlantis/atlantis/releases/download/v0.28.3/atlantis_linux_amd64.zip -P /root
# unzip /root/atlantis_linux_amd64.zip -d /root
# rm -rf /root/atlantis_linux_amd64.zip

##############################
# 4. Atlantis 서버 구동을 위한 변수 설정 (영구적 적용)
##############################
# cat <<EOF | sudo tee /etc/profile.d/atlantis.sh
# export USERNAME="ym1085"
# export URL="https://$(curl -s ipinfo.io/ip):4141"
# export REPO_ALLOWLIST="https://github.com/ym1085/terraform-for-ECS"
# EOF

# 환경변수 적용
# source /etc/profile.d/atlantis.sh

# 환경변수 확인
# echo "Atlantis 서버를 아래 설정으로 시작합니다:"
# echo "URL: $URL"
# echo "GitHub Username: $USERNAME"
# echo "Repo Allowlist: $REPO_ALLOWLIST"

##############################
# 5. Atlantis 서버 실행
##############################
# /root/atlantis server \
# --atlantis-url="$URL" \
# --gh-user="$USERNAME" \
# --gh-token="$TOKEN" \
# --gh-webhook-secret="$SECRET" \
# --repo-allowlist="$REPO_ALLOWLIST"