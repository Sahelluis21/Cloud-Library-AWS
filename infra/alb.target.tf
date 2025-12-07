resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Necessário para ECS Fargate
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"  
    interval            = 30
    timeout             = 10        # <--- AUMENTADO PARA EVITAR FAILING HEALTH CHECK
    healthy_threshold   = 2
    unhealthy_threshold = 3         # <--- Mais tolerante para evitar derrubar tarefa por instabilidade momentânea
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}
