###############################################################
# SUBNET GROUP (RDS usa somente subnets privadas)
###############################################################

###############################################################
# PARAMETER GROUP (opcional — mas recomendado)
###############################################################
resource "aws_db_parameter_group" "postgres" {
  name   = "${var.project_name}-postgres-params"
  family = "postgres14"

  parameter {
    name  = "log_min_duration_statement"
    value = "500"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }
}

###############################################################
# RDS INSTANCE (POSTGRES MULTI-AZ)
###############################################################
resource "aws_db_instance" "postgres" {
  identifier              = "${var.project_name}-db"
  engine                  = "postgres"
  engine_version          = "14"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"

  multi_az                = true

  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  parameter_group_name    = aws_db_parameter_group.postgres.name

  skip_final_snapshot     = true
  publicly_accessible     = false

  deletion_protection     = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}

###############################################################
# OUTPUTS
###############################################################
output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}
