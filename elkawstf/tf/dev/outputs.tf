# vpc outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.subnet_ids
}

output "route_table_id" {
  value = module.vpc.route_table_id
}

# security groups outputs
output "elasticsearch_sg_id" {
  value = module.securitygroup.elasticsearch_sg_id
}

output "kibana_sg_id" {
  value = module.securitygroup.kibana_sg_id
}

output "logstash_sg_id" {
  value = module.securitygroup.logstash_sg_id
}
