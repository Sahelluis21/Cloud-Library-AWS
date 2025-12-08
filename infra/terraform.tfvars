# --------------------------
# Projeto e Região
# --------------------------
project_name = "cloud-library"
region       = "us-east-1"

# --------------------------
# VPC
# --------------------------
vpc_cidr = "10.0.0.0/16"

# --------------------------
# Subnets Públicas (ALB)
# --------------------------
public_subnets = [
  "10.0.0.0/24",
  "10.0.3.0/24"
]

# --------------------------
# Subnets Privadas ECS
# --------------------------
private_subnets_ecs = [
  "10.0.1.0/24",
  "10.0.4.0/24"
]

# --------------------------
# Subnets Privadas RDS
# --------------------------
private_subnets_rds = [
  "10.0.2.0/24",
  "10.0.5.0/24"
]

# --------------------------
# ECS Containers
# --------------------------
php_image_url   = "791793563745.dkr.ecr.us-east-1.amazonaws.com/cloud-library-php:latest"
nginx_image_url = "791793563745.dkr.ecr.us-east-1.amazonaws.com/cloud-library-nginx:latest"

db_name       = "cloudlibrary"
db_user       = "cloudadmin"
db_password   = "SenhaMUUUUITOsegura123!"
init_sql_path = "./init.sql"
