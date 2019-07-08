terraform {
  backend "s3" {
    bucket = "staging-dataops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.33.0"

  allowed_account_ids = ["561276803310"]
}

module "dataops_environment" {
  source = "../../../modules/dataops_environment"

  environment     = "staging"
  vpc_cidr        = "10.200.208.0/21"
  private_subnets = ["10.200.208.0/24", "10.200.209.0/24", "10.200.210.0/24"]
  public_subnets  = ["10.200.211.0/24", "10.200.212.0/24", "10.200.213.0/24"]

  transit_vpc_account_id  = "556748783639"
  transit_vpc_id          = "vpc-2ee35b4a"
  transit_vpc_subnet_cidr = "10.201.0.0/16"
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
