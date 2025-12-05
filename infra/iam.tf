# Busca a role já existente no ambiente de laboratório
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# ECS Task Definition usando a LabRole
resource "aws_ecs_task_definition" "app" {
  family                   = "cloud-library-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"

  # Reaproveitando a role LabRole para execução e task
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.image_url
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}
