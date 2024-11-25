output "elasticsearch_sg_id" {
  value = aws_security_group.elasticsearch_sg.id
}

output "kibana_sg_id" {
  value = aws_security_group.kibana_sg.id
}

output "logstash_sg_id" {
  value = aws_security_group.logstash_sg.id
}
