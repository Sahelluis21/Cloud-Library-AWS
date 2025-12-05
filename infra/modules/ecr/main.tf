resource "aws_ecrpublic_repository" "this" {
  repository_name = var.repository_name

  tags = var.tags
}

resource "aws_ecrpublic_repository_policy" "public_policy" {
  repository_name = aws_ecrpublic_repository.this.repository_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowPublicAccess"
        Effect : "Allow"
        Principal : "*"
        Action : [
          "ecr-public:GetRepositoryPolicy",
          "ecr-public:DescribeRepositories",
          "ecr-public:BatchCheckLayerAvailability",
          "ecr-public:GetDownloadUrlForLayer",
          "ecr-public:BatchGetImage",
          "ecr-public:CompleteLayerUpload",
          "ecr-public:UploadLayerPart",
          "ecr-public:InitiateLayerUpload",
          "ecr-public:PutImage"
        ]
      }
    ]
  })
}
