# terraform state 파일 S3 버킷 생성
resource "aws_s3_bucket" "terraform_state" {
  for_each = var.s3_bucket

  #   region = var.aws_region
  bucket = each.value.bucket_name

  tags = merge(var.tags, {
    Name = "${each.value.bucket_name}-${local.env}"
  })
}

# terraform state 파일 s3 버전 관리 생성
resource "aws_s3_bucket_versioning" "terraform_state" {
  for_each = var.s3_bucket

  bucket = aws_s3_bucket.terraform_state[each.key].id
  versioning_configuration {
    status = "Enabled" # 버전 관리 설정 - true
  }
}

# terraform state 파일 s3 obj 암호화 수행
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  for_each = var.s3_bucket

  bucket = aws_s3_bucket.terraform_state[each.key].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # 암호화 Rule(규칙) 지정
    }
  }
}

# terraform state file s3 퍼블릭 access 제한
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  for_each = var.s3_bucket

  bucket                  = aws_s3_bucket.terraform_state[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
