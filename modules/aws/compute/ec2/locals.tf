locals {
  valid_ec2_security_group = [
    for sg in flatten(values(var.ec2_security_group)) :
    sg
    if sg != null && sg.ec2_security_group_name != null && length(keys(sg)) > 0
  ]

  valid_ec2_security_group_rules = [
    for rule in flatten(values(var.ec2_security_group_rules)) :
    rule
    if rule != null &&
    rule.ec2_security_group_name != null &&
    rule.type != null &&
    rule.from_port != null &&
    rule.to_port != null &&
    length(keys(rule)) > 0
  ]
}