# ---------- ECS Service ----------
resource "aws_ecs_service" "app" {
  name            = "cloud-library-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.ecs_private[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  # O ALB sempre aponta para o container NGINX (correto!)
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "nginx"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  force_new_deployment = true

  depends_on = [
    aws_lb_listener.http,
    aws_lb_target_group.app
  ]

  tags = {
    Name = "cloud-library-service"
  }
}
