variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}


