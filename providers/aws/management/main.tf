terraform {
  backend "s3" {
    bucket = "management-dataops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.29.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["645025723021"]
}

module "management" {
  source = "../../../modules/management"
}

output "jump_box_fqdn" {
  value = "${module.management.jump_box_fqdn}"
}

output "route53_name_servers" {
  value = "${module.management.route53_name_servers}"
}

/*
output "concourse_fqdn" {
  value = "${module.management.concourse_fqdn}"
}
*/

