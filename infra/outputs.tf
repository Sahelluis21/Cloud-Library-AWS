output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "ecs_private_subnets" {
  value = aws_subnet.ecs_private[*].id
}

output "rds_private_subnets" {
  value = aws_subnet.rds_private[*].id
}

output "bucket_id" {
  value = aws_s3_bucket.main.id
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
