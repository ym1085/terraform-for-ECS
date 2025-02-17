# EC2 security group
resource "aws_security_group" "ec2_security_group" {
  for_each = {
    for sg in local.valid_ec2_security_group :
    sg.ec2_security_group_name => sg
  }

  name        = each.value.ec2_security_group_name
  description = each.value.ec2_security_group_description
  vpc_id      = var.vpc_id # module에서 넘겨 받아야함

  lifecycle {
    create_before_destroy = true # 리소스 삭제 되기 전 생성 후 삭제 진행
  }

  tags = merge(var.tags, {
    Name = "${each.value.ec2_security_group_name}-${var.env}"
  })
}

# EC2 security group rule
resource "aws_security_group_rule" "ec2_ingress_security_group" {
  for_each = {
    for rule in local.valid_ec2_security_group_rules :
    "${rule.ec2_security_group_name}-${rule.type}-${rule.from_port}-${rule.to_port}" => rule
  }

  description       = each.value.description                                                       # 보안그룹 DESC
  security_group_id = aws_security_group.ec2_security_group[each.value.ec2_security_group_name].id # 참조하는 보안그룹 ID
  type              = each.value.type                                                              # 타입 지정(ingress, egress)
  from_port         = each.value.from_port                                                         # 포트 시작 허용 범위
  to_port           = each.value.to_port                                                           # 포트 종료 허용 범위
  protocol          = each.value.protocol                                                          # 보안그룹 프로토콜 지정

  cidr_blocks              = try(each.value.cidr_ipv4, null)                # 허용할 IP 범위
  source_security_group_id = try(each.value.source_security_group_id, null) # 인바운드로 보안그룹이 들어가야 하는 경우 사용
}

# EC2 Instance
# resource "aws_instance" "ec2" {
# }