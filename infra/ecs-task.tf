resource "aws_ecs_task_definition" "app" {
  family                   = "cloud-library-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([

    # -----------------------
    # CONTAINER PHP-FPM
    # -----------------------
    {
      name      = "php-fpm"
      image     = var.php_image_url
      essential = true
      cpu       = 128
      memory    = 256
      workingDirectory = "/var/www/html"


      

      # Este container só é acessado internamente pelo Nginx.
      portMappings = [
        {
          containerPort = 9000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_app.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "php"
        }
      }
    },

    # -----------------------
    # CONTAINER NGINX
    # -----------------------
    {
      name      = "nginx"
      image     = var.nginx_image_url
      essential = true
      cpu       = 128
      memory    = 256
    
        dependsOn = [
        {
          containerName = "php-fpm"
          condition     = "START"
        }
      ]

      # Nginx expõe a porta que o ALB irá acessar
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_app.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "nginx"
        }
      }
    }
  ])
}
