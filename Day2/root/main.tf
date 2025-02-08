module "vpc" {
  source       = "../modules/vpc"
  project_name = var.project_name # passing variable from root to child module
  vpc_cidr     = var.vpc_cidr
}
