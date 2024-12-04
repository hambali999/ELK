output "elasticsearch_private_ip" {
  value = module.elasticsearch.elasticsearch_private_ip
}

output "app1_instance_public_ip" {
  value = module.app1.instance_public_ip
}

output "app2_instance_public_ip" {
  value = module.app2.instance_public_ip
}