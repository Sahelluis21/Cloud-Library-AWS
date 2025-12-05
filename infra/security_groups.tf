# security_groups.tf

# ALB SG: permite 80/443 do mundo
resource "aws_security_group" "alb_sg" {
  name        = "cloud-library-alb-sg"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-library-alb-sg"
  }
}

# ECS SG: permite tráfego apenas vindo do ALB
resource "aws_security_group" "ecs_sg" {
  name        = "cloud-library-ecs-sg"
  description = "Security group for ECS tasks (allow traffic from ALB)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "From ALB HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "From ALB HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow outbound to anywhere (e.g., RDS endpoint, S3, Internet via NAT)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-library-ecs-sg"
  }
}

# RDS SG: permite 5432 apenas vindos do ECS SG
resource "aws_security_group" "rds_sg" {
  name        = "cloud-library-rds-sg"
  description = "RDS security group; allow Postgres from ECS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Postgres from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-library-rds-sg"
  }
}

# Outputs (úteis para outras configs)
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
