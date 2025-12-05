module "vpc" {
  source = "./modules/vpc"

  project_name = "cloud-library"
  vpc_cidr     = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

module "s3" {
  source       = "./modules/s3"
  project_name = "cloud-library"
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "cloud-library"

  tags = {
    Project = "CloudLibrary"
    Env     = "Prod"
  }
}



