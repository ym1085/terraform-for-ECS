# AWS Codecommit Repository 생성
resource "aws_codecommit_repository" "code_commit" {
  for_each = var.code_commit

  repository_name = each.value.repository_name # codecommit repo 이름 지정(100자 이내)
  description     = each.value.description     # codecommit repo 설명
  default_branch  = each.value.default_branch  # 기본 브랜치 설정(master)

  tags = merge(var.tags, {
    Name = "${each.value.repository_name}-${each.value.env}"
  })
}
