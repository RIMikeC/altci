terraform {
  backend "s3" {
    bucket = "prod-dataops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.33.0"

  allowed_account_ids = ["665109639135"]
}

module "dataops_environment" {
  source = "../../../modules/dataops_environment"

  environment     = "prod"
  vpc_cidr        = "10.202.176.0/21"
  private_subnets = ["10.202.176.0/24", "10.202.177.0/24", "10.202.178.0/24"]
  public_subnets  = ["10.202.179.0/24", "10.202.180.0/24", "10.202.181.0/24"]

  transit_vpc_account_id  = "376076567968"
  transit_vpc_id          = "vpc-2efefe4a"
  transit_vpc_subnet_cidr = "10.202.0.0/22"
}

output "vpc_id" {
  value = "${module.dataops_environment.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.dataops_environment.vpc_cidr}"
}

output "vpc_private_subnets" {
  value = "${module.dataops_environment.vpc_private_subnets}"
}

output "availability_zones" {
  value = "${module.dataops_environment.availability_zones}"
}

output "ec2_key_pair_name" {
  value = "${module.dataops_environment.ec2_key_pair_name}"
}

output "aws_zone_id" {
  value = "${module.dataops_environment.aws_zone_id}"
}

output "jump_box_fqdn" {
  value = "${module.dataops_environment.jump_box_fqdn}"
}

output "route53_name_servers" {
  value = "${module.dataops_environment.route53_name_servers}"
}
