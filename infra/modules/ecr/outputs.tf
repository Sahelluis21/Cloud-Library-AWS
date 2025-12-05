output "repository_uri" {
  description = "URI pública do repositório"
  value       = aws_ecrpublic_repository.this.repository_uri
}

output "registry_id" {
  description = "ID do registro ECR público"
  value       = aws_ecrpublic_repository.this.registry_id
}
