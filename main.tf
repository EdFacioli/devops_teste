module "network" {
  source = "./modules/network"

  environment_id = var.environment_id
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.repository_name
}