# modules/aws/cicd/codecommit/outputs.tf

# CodeCommit 저장소의 ID 반환
output "repository_id" {
  description = "CodeCommit 저장소의 ID 반환"
  value       = { for k, v in aws_codecommit_repository.code_commit : k => v.id }
}

# CodeCommit 저장소의 ARN 반환
output "arn" {
  description = "CodeCommit 저장소의 ARN 반환"
  value       = { for k, v in aws_codecommit_repository.code_commit : k => v.arn }
}

# CodeCommit 저장소의 clone_url_http 반환
output "clone_url_http" {
  description = "CodeCommit 저장소의 clone_url_http 반환"
  value       = { for k, v in aws_codecommit_repository.code_commit : k => v.clone_url_http }
}

# CodeCommit 저장소의 clone_url_ssh 반환
output "clone_url_ssh" {
  description = "CodeCommit 저장소의 clone_url_ssh 반환"
  value       = { for k, v in aws_codecommit_repository.code_commit : k => v.clone_url_ssh }
}

# CodeCommit 저장소의 default branch 반환
output "default_branch" {
  description = "CodeCommit 저장소의 default branch 반환"
  value       = { for k, v in aws_codecommit_repository.code_commit : k => v.default_branch }
}
