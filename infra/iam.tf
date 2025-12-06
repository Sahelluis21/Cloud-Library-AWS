# Busca a role já existente no ambiente de laboratório
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}



