# ---------- ALB ----------
resource "aws_lb" "app" {
  name               = "cloud-library-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "cloud-library-alb"
  }
}
