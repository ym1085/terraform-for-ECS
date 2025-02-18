locals {
  # EC2 보안그룹 설정을 위해, module에서 받은 변수 유효성 검사 후 셋팅
  valid_ec2_security_group = [
    for sg in flatten(values(var.ec2_security_group)) :
    sg
    if sg != null && sg.ec2_security_group_name != null && length(keys(sg)) > 0
  ]

  # EC2 보안그룹 규칙 설정을 위해, module에서 받은 변수 유효성 검사 후 셋팅
  # EC2 보안그룹 Ingress 설정
  valid_ec2_security_group_ingress_rules = [
    for rule in flatten(values(var.ec2_security_group_ingress_rules)) :
    rule
    if rule != null &&
    rule.ec2_security_group_name != null &&
    rule.type != null &&
    rule.from_port != null &&
    rule.to_port != null &&
    length(keys(rule)) > 0
  ]

  # EC2 보안그룹 Egress 설정
  valid_ec2_security_group_egress_rules = [
    for rule in flatten(values(var.ec2_security_group_egress_rules)) :
    rule
    if rule != null &&
    rule.ec2_security_group_name != null &&
    rule.type != null &&
    rule.from_port != null &&
    rule.to_port != null &&
    length(keys(rule)) > 0
  ]
}
