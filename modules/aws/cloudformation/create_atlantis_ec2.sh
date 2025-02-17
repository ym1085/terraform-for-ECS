#!/bin/bash
echo -e "CloudFormation 기반 Atlantis EC2 서버 구성..."
sleep 5

aws cloudformation deploy --template-file t101-atlantis-ec2.yaml --stack-name t101 --parameter-overrides KeyName=$MYKEYNAME SgIngressSshCidr=$(curl -s ipinfo.io/ip)/32 --region ap-northeast-2
aws cloudformation describe-stacks --stack-name t101 --query 'Stacks[*].Outputs[0].OutputValue' --output text