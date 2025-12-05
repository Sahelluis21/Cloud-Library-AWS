# iam.tf

# Task execution role (ECS needs this to pull images and push logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-cloud-library"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach managed policies (standard)
resource "aws_iam_role_policy_attachment" "exec_ecs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "exec_ecr_read" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "exec_cloudwatch" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# -------------------------------------------------
# Task role (role assumida pelo container) - grant S3 / secrets access
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-cloud-library"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Minimal inline policy to allow S3 access and read secrets (you can tighten later)
resource "aws_iam_policy" "app_s3_secrets_policy" {
  name = "cloud-library-app-s3-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
        "arn:aws:s3:::${module.s3.bucket_id}",
        "arn:aws:s3:::${module.s3.bucket_id}/*"
        ]
      },
      {
        Sid = "SecretsManagerRead",
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_attach_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.app_s3_secrets_policy.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
