# FIXME: IAM Role도 FOR - LOOP로 처리하는게 맞을지 모르겠음..
# IAM은 아무래도 수정이 계속 발생할 것 같기도 하고..

# 기존 존재하는 IAM Role 조회
data "aws_iam_role" "existing_roles" {
  for_each = {
    for role in flatten([
      for role_group in var.iam_role : role_group[*]
    ]) : role.name => role if lookup(role, "existing", false)
  }
  name = each.value.name
}

# 기존 존재하는 IAM Policy 조회
data "aws_iam_policy" "existing_policies" {
  for_each = {
    for policy in flatten([
      for policy_group in var.iam_policy : policy_group[*]
    ]) : policy.name => policy if lookup(policy, "existing", false) # policy 안에 existing key가 있으면 반환
  }
  arn = each.value.arn
}

# IAM Role 생성
resource "aws_iam_role" "new_roles" {
  for_each = {
    for role in flatten([
      for role_key, role_values in var.iam_role : [
        for role in role_values : role
      ]
    ]) : role.name => role if !lookup(role, "existing", false) # role 안에 existing key가 없는 경우
  }

  name = each.value.name
  assume_role_policy = jsonencode({
    Version   = each.value.version
    Statement = each.value.statement
  })
}

# IAM Policy 생성
resource "aws_iam_policy" "new_policies" {
  for_each = {
    for policy in flatten([
      for policy_key, policy_values in var.iam_policy : [
        for policy in policy_values : policy
      ]
    ]) : policy.name => policy if !lookup(policy, "existing", false)
  }

  name = each.value.name
  policy = jsonencode({
    Version   = each.value.version
    Statement = each.value.statement
  })
}

# IAM Role에 Policy Attachment
resource "aws_iam_role_policy_attachment" "iam_attachment" {
  for_each = {
    for attachment in flatten([
      for attachment_group in var.iam_policy_attachment : attachment_group[*]
    ]) : "${attachment.policy_type}-${attachment.role}" => attachment
  }

  # lookup(map, key, default)
  role = lookup(
    aws_iam_role.new_roles, each.value.role, lookup(data.aws_iam_role.existing_roles, each.value.role, null)
  ).name

  # lookup(map, key, default)
  policy_arn = lookup(
    aws_iam_policy.new_policies, each.value.policy, lookup(data.aws_iam_policy.existing_policies, each.value.policy, null)
  ).arn
}

# ECS AutoScaling Role에 Auto Scaling 관련 Policy(정책) 연결
# Policy: AmazonEC2ContainerServiceAutoscaleRole
# resource "aws_iam_role_policy_attachment" "ecs_auto_scaling_role_policy_attachment" {
#   role       = aws_iam_role.ecs_auto_scaling_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/${var.ecs_auto_scaling_policy_arn}"
# }
