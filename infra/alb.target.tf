resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # Necessário para ECS Fargate
  target_type = "ip"

  health_check {
    path                = "/"          # endpoint mais leve possível
    protocol            = "HTTP"
    matcher             = "200-399"    # aceita qualquer resposta válida
    interval            = 30
    timeout             = 10           # evita timeouts falsos
    healthy_threshold   = 2            # fica saudável rápido
    unhealthy_threshold = 5            # agora muito mais tolerante
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}
