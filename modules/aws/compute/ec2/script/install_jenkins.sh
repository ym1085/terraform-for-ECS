#!/bin/bash

# 시스템 패키지 업데이트
sudo yum update -y

# Jenkins 저장소 구성 다운로드
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Jenkins GPG 키 등록
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# 패키지 업그레이드
sudo yum upgrade -y

# Java 11(Amazon Corretto) 설치
sudo dnf install java-11-amazon-corretto -y

# Jenkins 설치
sudo yum install jenkins -y

# Jenkins 자동 시작 활성화
sudo systemctl enable jenkins

# Jenkins 즉시 실행
sudo systemctl start jenkins