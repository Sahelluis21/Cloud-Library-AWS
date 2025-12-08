terraform {
  required_version = ">= 1.7"

  # Se você usar backend remoto (opcional)
  # backend "s3" {
  #   bucket = "meu-terraform-state"
  #   key    = "cloud-library/terraform.tfstate"
  #   region = var.region
  # }
}
