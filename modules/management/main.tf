// Create A VPC with multi AZ private and public subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.37.0"

  name            = "${var.project_name}-${var.module_instance_id}"
  cidr            = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  // enable nat gateway
  enable_nat_gateway = "true"

  // This sets the search domain in DHCP options
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    "Name"         = "${var.environment}-${var.project_name}-${var.module_instance_id}"
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

resource "aws_key_pair" "default_mgmt" {
  key_name   = "${var.project_name}-${var.environment}-default-mgmt"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

module "jump_box" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/jump_box?ref=12e6709d0c32da782e5dd2508445e4ba65ea2d77"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"
  vpc_id       = "${module.vpc.vpc_id}"
  ssh_key_name = "${aws_key_pair.default_mgmt.key_name}"
  subnet       = "${element(module.vpc.public_subnets, 0)}"
  public       = "true"

  jump_box_allowed_range_enable = "true"
  jump_box_allowed_range        = ["193.105.212.250/32", "80.168.1.186/32"]
}

resource "aws_route53_record" "jump_box" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  name    = "jump"
  type    = "A"
  ttl     = "60"
  records = ["${module.jump_box.ip_address}"]
}

resource "aws_kms_key" "concourse_ci_vc8" {}

resource "aws_kms_alias" "concourse_ci_vc8" {
  name          = "alias/concourse_ci_vc8_new"
  target_key_id = "${aws_kms_key.concourse_ci_vc8.key_id}"
}

data "aws_ami" "aws_ecs_optimised_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_region" "current" {}

# approle auth
module "concourse_ci" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/concourse_ci?ref=faad2a980009de194a5cce412bef133afbaadfb6"

  project_name   = "${var.project_name}"
  project_domain = "io"
  environment    = "${var.environment}"

  vpc_id            = "${module.vpc.vpc_id}"
  public_subnets    = "${module.vpc.public_subnets}"
  private_subnets   = "${module.vpc.private_subnets}"
  vpc_subnet        = "${var.vpc_cidr}"
  ec2_key_pair      = "${aws_key_pair.default.key_name}"
  ecs_instance_type = "i3.large"

  postgres_multi_az            = "true"
  postgres_skip_final_snapshot = "false"

  aws_asg_image_id = "ami-acb020d5"

  kms_key_arn = "${aws_kms_key.concourse_ci_vc8.arn}"

  encrypted_keys          = "${var.concourse_ci_encrypted_keys}"
  transit_vpc_subnet_cidr = "10.202.0.0/22"

  // allow the instance to assume the cd roles in project accounts
  additional_ecs_instance_role_policy = "${file("${path.module}/iam_policies/ecs_instance.json")}"

  // encrypted with kms
  config_basic_auth_encrypted_password = "AQICAHiu+8+Mvh50iKX1lwUBNBn0sQ4fOrXSEfQqs+kV9rnS2gGnBjobC6zF8Ta/FRk976QHAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMcCp4eSgRc6z/NSwpAgEQgDshlrMo2iPeM+Kx6cZJ3XY7TcbtqEF9wfspJv69tLC1jTkRCHd6ETxjnSlEJiqc26N8mZhvkVA+y/NzIg=="
  config_postgres_encrypted_password   = "AQICAHiu+8+Mvh50iKX1lwUBNBn0sQ4fOrXSEfQqs+kV9rnS2gGOJDqdvBR1nLa3CBHXJHPqAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMn2fKGQkt5dBmhWmjAgEQgDtfNW7nLNNdDZ3dB4Pi4DPZAlQDQ5VvbPwNRAz122NMbbN27QP5Fh3EpgUNe7nEPmoTkV5GJYrFGeurVQ=="
  config_github_auth_client_secret     = "AQICAHiu+8+Mvh50iKX1lwUBNBn0sQ4fOrXSEfQqs+kV9rnS2gGqcGljnTHZ/CIqjGWzNwufAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGdb9mzCSSWyGjryMQIBEIBDW2FMO0xRGTK9TnO0NcRKSdOdymm9vlNFIkquMSsTQqqZVBSpZWUEQdUaeRFCEiUHH4ij5Px36htyKMf/tJyNLFqHoA=="

  config_github_auth_client_id = "944db207772345ff43fa"
  config_github_auth_team      = "River-Island/dataops-cd"
  config_external_url          = "http://${var.project_name}-concourse.prod.transit.ri-tech.io"
  concourse_version            = "3.14.1"
  concourse_init_version       = "0.0.22"
  number_of_workers            = "1"

  # the encrypted values are encrypted with kms.
  web_additional_env_vars = <<EOF
{
  "name": "AWS_REGION",
  "value": "${data.aws_region.current.name}"
},
{
  "name": "CONCOURSE_AWS_SECRETSMANAGER_PIPELINE_SECRET_TEMPLATE",
  "value": "/concourse/{{.Team}}/{{.Pipeline}}/{{.Secret}}"
},
{
  "name": "CONCOURSE_AWS_SECRETSMANAGER_TEAM_SECRET_TEMPLATE",
  "value": "/concourse/{{.Team}}/{{.Secret}}"
}
EOF
}

resource "aws_route53_record" "concourse_ci" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  name    = "concourse"
  type    = "CNAME"
  ttl     = "60"
  records = ["${module.concourse_ci.elb_dns_name}"]
}

// outputs
output "aws_kms_key_concourse_ci" {
  value = "${aws_kms_key.concourse_ci_vc8.arn}"
}

output "jump_box_fqdn" {
  value = "${aws_route53_record.jump_box.fqdn}"
}

output "concourse_fqdn" {
  value = "${aws_route53_record.concourse_ci.fqdn}"
}
