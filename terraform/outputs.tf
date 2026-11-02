output "vpc_id" {
  description = "ID of the lab VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private application subnet IDs."
  value       = module.network.private_subnet_ids
}
