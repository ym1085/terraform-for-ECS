variable "ecr_repository" {
  description = "ECR repository"
  type = map(object({
    ecr_repository_name      = string
    environment              = string
    ecr_image_tag_mutability = string
    ecr_scan_on_push         = bool
    ecr_force_delete         = bool
    tags                     = map(string)
  }))
}
