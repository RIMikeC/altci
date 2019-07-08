// Create A VPC with multi AZ private and public subnets
module "vpc" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=f7a874cb2c74815d301608c3fe6eadf02cc57be5"
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

// SSH Keypair
resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

resource "aws_route53_zone" "environment" {
  name = "${var.environment}.${var.project_name}.ri-tech.io"

  tags {
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

# Create subdomain for the k8s cluster
resource "aws_route53_zone" "k8s_zone" {
  name = "k8s.${aws_route53_zone.environment.name}"

  tags = {
    Environment = "${var.environment}"
  }
}

# Add NS entry to the main hosted zone <env>.<proj>.ri-tech.io, for the new k8s hosted zone.
resource "aws_route53_record" "k8s_ns_record" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  name    = "k8s.${aws_route53_zone.environment.name}"
  type    = "NS"
  ttl     = "300"
  records = ["${aws_route53_zone.k8s_zone.name_servers}"]
}

output "route53_k8s_zone" {
  value = "${aws_route53_zone.k8s_zone.name}"
}

output "route53_k8s_name_servers" {
  value = "${aws_route53_zone.k8s_zone.name_servers}"
}
