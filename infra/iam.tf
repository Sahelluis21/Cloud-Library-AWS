# Usa a IAM Role já existente no laboratório
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Opcional (mas recomendável): força dependência explícita
# Isso garante que ECS não tente criar a TaskDefinition antes de "ler" a role
resource "null_resource" "ensure_lab_role" {
  triggers = {
    role_arn = data.aws_iam_role.lab_role.arn
  }
}
