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

module "elasticsearch" {
  source                              = "../modules/elasticsearch"
  public_subnet_ids                   = module.vpc.subnet_ids
  aws_security_group_elasticsearch_sg = module.securitygroup.elasticsearch_sg_id
}

