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
  source              = "../../../elkawstfpersonal/tf/modules/elasticsearch"
  elasticsearch_sg_id = module.securitygroup.elasticsearch_sg_id
  subnet_ids          = module.vpc.subnet_ids
}