variable "elastic_aws_ami" {
  description = "AMI ID for Elasticsearch nodes"
  type        = string
  default     = "ami-0adae34e7f9b49b75"
}

variable "elastic_aws_instance_type" {
  description = "Instance type for Elasticsearch nodes"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "aws_security_group_elasticsearch_sg" {
  description = "elasticsearch security group id"
  type        = list(string)
}

# variable "azs" {
#   description = "List of availability zones"
#   type        = list(string)
# }
