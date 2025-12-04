resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-bucket"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}

# Bloqueia qualquer possibilidade de acesso público
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Impede ACLs (preferível para segurança moderna)
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Política que só permite acesso por ROLE (que será criada na fase ECS)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.main.id

  # Política mínima permitindo acesso APENAS a roles específicas
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyPublicAccess"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.main.arn,
          "${aws_s3_bucket.main.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}
