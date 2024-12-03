variable "kibana_sg_id" {
  description = "The kibana securiy group id"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the Elasticsearch stack"
  type        = list(string)
}

variable "aws_iam_instance_profile_name" {
  description = "The instance profile name"
  type        = string
}

variable "elasticsearch_private_ip" {
  description = "The elasticsearch private ip address"
  type        = string
  default = "127.0.0.1" 
}


