output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "vpc_cidr" {
  value = "${var.vpc_cidr}"
}

output "availability_zones" {
  value = "${var.availability_zones}"
}

output "ec2_key_pair_name" {
  value = "${aws_key_pair.default.key_name}"
}

output "aws_zone_id" {
  value = "${aws_route53_zone.environment.zone_id}"
}

output "jump_box_security_group" {
  value = "${module.jump_box.security_group_id}"
}

output "route53_name_servers" {
  value = "${aws_route53_zone.environment.name_servers}"
}
