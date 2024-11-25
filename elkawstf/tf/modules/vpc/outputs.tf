output "vpc_id" {
  value = aws_vpc.elastic_stack_vpc.id
}

output "subnet_ids" {
  value = values(aws_subnet.elastic_stack_subnet)[*].id
}

output "route_table_id" {
  value = aws_route_table.elastic_stack_rt.id
}
