variable "repository_name" {
  description = "Nome do repositório ECR público"
  type        = string
}

variable "tags" {
  description = "Tags do repositório"
  type        = map(string)
  default     = {}
}
