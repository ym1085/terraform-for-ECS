# FIXME: IAM Role도 FOR - LOOP로 처리하는게 맞을지 모르겠음..
# IAM은 아무래도 수정이 계속 발생할 것 같기도 하고..

# AmazonEC2ContainerServiceAutoscaleRole
data "aws_iam_policy" "ecs_auto_scaling_policy" {
  name = var.ecs_auto_scaling_policy_arn
}

# IAM Role 생성
resource "aws_iam_role" "iam_role" {
  for_each = {
    for role in flatten([
      for role_key, role_values in var.iam_role : [
        for role in role_values : role
      ]
    ]) : role.name => role
  }

  name = each.value.name
  assume_role_policy = jsonencode({
    Version   = each.value.version
    Statement = each.value.statement
  })
}

# IAM Policy 생성
resource "aws_iam_policy" "iam_policy" {
  for_each = {
    for policy in flatten([
      for policy_key, policy_values in var.iam_policy : [
        for policy in policy_values : policy
      ]
    ]) : policy.name => policy
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
    for policy_attachment in flatten([
      for policy_attachment_key, policy_attachment_values in var.iam_policy_attachment : [
        for policy_attachment in policy_attachment_values : merge({ policy_type = policy_attachment_key }, policy_attachment)
      ]
    ]) : "${policy_attachment.policy_type}-${policy_attachment.role}" => policy_attachment
  }

  role       = aws_iam_role.iam_role[each.value.role].name
  policy_arn = aws_iam_policy.iam_policy[each.value.policy].arn
}

# ECS AutoScaling Role에 Auto Scaling 관련 Policy(정책) 연결
# Policy: AmazonEC2ContainerServiceAutoscaleRole
resource "aws_iam_role_policy_attachment" "ecs_auto_scaling_role_policy_attachment" {
  role       = aws_iam_role.ecs_auto_scaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/${var.ecs_auto_scaling_policy_arn}"
}
