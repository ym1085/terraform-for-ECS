#!/bin/bash
hostnamectl --static set-hostname Atlantis

# Config convenience
echo 'alias vi=vim' >> /etc/profile
echo "sudo su -" >> /home/ubuntu/.bashrc

# Install Packages & Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update -qq && apt install tree jq unzip zip terraform -y

# Install aws cli version2 - AWS CLI 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install atlantis - Atlantis 설치
wget https://github.com/runatlantis/atlantis/releases/download/v0.28.3/atlantis_linux_amd64.zip -P /root
unzip /root/atlantis_linux_amd64.zip -d /root && rm -rf /root/atlantis_linux_amd64.zip