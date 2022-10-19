output "url_repository" {
  value = module.ecr.ecr_repository
}

output "sg_id" {
  value = module.network.sg_id
}

output "cluster_name" {
  value = module.ecs.cluster_name
}

output "subnets_private" {
  value = module.network.subnets_private
}

output "subnets_public" {
  value = module.network.subnets_public
}