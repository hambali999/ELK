variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "Name of the SSH key to access the instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "default_tags" {
  description = "Default tags for the instance"
  type        = map(string)
  default     = {}
}

variable "logstash_sg_id" {
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
  default     = "127.0.0.1"
}
