variable "project_name" {
  type        = string
  description = "Nome do projeto usado como prefixo em recursos AWS"
  default     = "cloud-library"
}

variable "region" {
  type        = string
  description = "Região AWS"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR da VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Lista de CIDRs das subnets públicas (para ALB)"
}

variable "private_subnets_ecs" {
  type        = list(string)
  description = "Lista de CIDRs das subnets privadas para ECS"
}

variable "private_subnets_rds" {
  type        = list(string)
  description = "Lista de CIDRs das subnets privadas para RDS"
}

# -------------------------------------------------
# NOVOS: dois repositórios, um para PHP e outro para Nginx
# -------------------------------------------------

variable "php_image_url" {
  type        = string
  description = "URL da imagem PHP (FPM) no ECR"
}

variable "nginx_image_url" {
  type        = string
  description = "URL da imagem Nginx no ECR"
}
variable "db_name" {
  description = "Nome do banco padrão a ser criado no RDS"
  type        = string
}

variable "db_user" {
  description = "Usuário master do banco"
  type        = string
}

variable "db_password" {
  description = "Senha do usuário master"
  type        = string
  sensitive   = true
}

variable "init_sql_path" {
  description = "Caminho do arquivo init.sql"
  type        = string
}
