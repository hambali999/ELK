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

