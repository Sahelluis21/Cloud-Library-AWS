# ---------- ALB HTTP Listener ----------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# ---------- ALB HTTPS Listener (opcional) ----------
# Para habilitar HTTPS, precisa do certificado ACM
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.app.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxx"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
# }
