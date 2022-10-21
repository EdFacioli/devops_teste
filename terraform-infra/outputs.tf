output "url_repository" {
  value = module.ecr.ecr_repository
}

output "cluster_id" {
  value = module.ecs.cluster_id
}

output "subnets_private" {
  value = module.network.subnets_private
}

output "subnets_public" {
  value = module.network.subnets_public
}

output "vpc_id" {
  value = module.network.vpc_id
}