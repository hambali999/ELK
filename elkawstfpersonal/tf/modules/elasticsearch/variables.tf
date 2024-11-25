variable "elasticsearch_sg_id" {
  description = "The elasticsearch securiy group id"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the Elasticsearch stack"
  type        = list(string)
}

# variable "PAT" {
#   description = "Path to the public key file"
#   type        = string
#   default     = "./elasticsearch/key.pub" # Provide a default path if needed
# }


