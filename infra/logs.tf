resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/cloud-library-app"
  retention_in_days = 14

  tags = {
    Name = "cloud-library-ecs-logs"
  }
}
