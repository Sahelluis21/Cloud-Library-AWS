###############################################################
# EXECUTAR init.sql APÓS O RDS ESTAR DISPONÍVEL
###############################################################
resource "null_resource" "init_rds" {
  depends_on = [
    aws_db_instance.postgres
  ]

  provisioner "local-exec" {
    command = <<EOT
PGPASSWORD=${var.db_password} psql \
  -h ${aws_db_instance.postgres.address} \
  -U ${var.db_user} \
  -d ${var.db_name} \
  -f ${var.init_sql_path}
EOT
  }
}
