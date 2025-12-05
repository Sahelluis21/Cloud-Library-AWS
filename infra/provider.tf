terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend remoto opcional
  # backend "s3" {
  #   bucket = "meu-terraform-state"
  #   key    = "cloud-library/terraform.tfstate"
  #   region = var.region
  # }
}

provider "aws" {
  region = var.region
}
