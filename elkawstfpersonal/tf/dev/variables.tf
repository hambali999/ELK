variable "key_name" {
  description = "Name of the SSH key to access instances"
  type        = string
  default     = "tfkey"
}

variable "environment" {
  description = "Environment for the instances"
  type        = string
  default     = "dev"
}

variable "app1_ami_id" {
  description = "AMI ID for App 1"
  type        = string
  default     = "ami-047126e50991d067b"
}

variable "app1_instance_type" {
  description = "Instance type for App 1"
  type        = string
  default     = "t2.medium"
}

variable "app2_ami_id" {
  description = "AMI ID for App 2"
  type        = string
  default     = "ami-047126e50991d067b"

}

variable "app2_instance_type" {
  description = "Instance type for App 2"
  type        = string
  default     = "t2.medium"
}
