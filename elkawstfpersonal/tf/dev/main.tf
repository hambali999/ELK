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
}
