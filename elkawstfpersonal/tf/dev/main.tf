module "vpc" {
  source = "../modules/vpc"
  tags = {
    Environment = "dev"
    Project     = "example-elk-aws-tf"
  }
}

module "securitygroup" {
  source = "../modules/securitygroup"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "../modules/iam"
}

module "elasticsearch" {
  source                        = "../modules/elasticsearch/"
  elasticsearch_sg_id           = module.securitygroup.elasticsearch_sg_id
  subnet_ids                    = module.vpc.subnet_ids
  aws_iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
}

module "kibana" {
  source                        = "../modules/kibana/"
  kibana_sg_id                  = module.securitygroup.kibana_sg_id
  subnet_ids                    = module.vpc.subnet_ids
  aws_iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
  elasticsearch_private_ip      = module.elasticsearch.elasticsearch_private_ip
}

module "app1" {
  source                        = "../modules/ubuntu-app/"
  ami_id                        = var.app1_ami_id
  instance_type                 = var.app1_instance_type
  key_name                      = var.key_name
  instance_name                 = "App1-Instance-Logstash"
  default_tags                  = { environment = var.environment }
  logstash_sg_id                = module.securitygroup.logstash_sg_id
  subnet_ids                    = module.vpc.subnet_ids
  aws_iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
  elasticsearch_private_ip      = module.elasticsearch.elasticsearch_private_ip
  script_path                   = "${path.module}/scripts/logstash_start.sh" # Path to app1 script
}

module "app2" {
  source                        = "../modules/ubuntu-app/"
  ami_id                        = var.app2_ami_id
  instance_type                 = var.app2_instance_type
  key_name                      = var.key_name
  instance_name                 = "App2-Instance-Logstash"
  default_tags                  = { environment = var.environment }
  logstash_sg_id                = module.securitygroup.logstash_sg_id
  subnet_ids                    = module.vpc.subnet_ids
  aws_iam_instance_profile_name = module.iam.aws_iam_instance_profile_name
  elasticsearch_private_ip      = module.elasticsearch.elasticsearch_private_ip
  script_path                   = "${path.module}/scripts/logstash_start.sh" # Path to app1 script
}
