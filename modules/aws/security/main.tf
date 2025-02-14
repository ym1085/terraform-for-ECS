# ECS Task Role 생성
resource "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ECS Task Role Policy 생성
resource "aws_iam_policy" "ecs_task_role_policy" {
  name = var.ecs_task_role_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# ECS Task Role Attachment
resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

# ECS Task Exec Role 생성
resource "aws_iam_role" "ecs_task_exec_role" {
  name = var.ecs_task_exec_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ECS Task Exec Role Policy 생성
resource "aws_iam_policy" "ecs_task_exec_role_policy" {
  name        = var.ecs_task_exec_role_policy
  description = var.ecs_task_exec_role_policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# ECS Task Exec Role Attachment
resource "aws_iam_role_policy_attachment" "ecs_task_exec_role_policy" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = aws_iam_policy.ecs_task_exec_role_policy.arn
}

# ECS AutoScaling 관련 IAM Role 생성
resource "aws_iam_role" "ecs_auto_scaling_role" {
  name = var.ecs_auto_scaling_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AutoScaling"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        }
      }
    ]
  })
}

# ECS AutoScaling Role에 Auto Scaling 관련 Policy(정책) 연결
# Policy: AmazonEC2ContainerServiceAutoscaleRole
resource "aws_iam_role_policy_attachment" "ecs_auto_scaling_role_policy_attachment" {
  role       = aws_iam_role.ecs_auto_scaling_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/${var.ecs_auto_scaling_policy_arn}"
}
