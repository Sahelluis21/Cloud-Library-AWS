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

variable "image_url" {
  type        = string
  description = "URL da imagem do Docker para ECS (ECR ou Docker Hub)"
}
