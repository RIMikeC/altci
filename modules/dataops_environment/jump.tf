module "jump_box" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/jump_box?ref=12e6709d0c32da782e5dd2508445e4ba65ea2d77"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"
  vpc_id       = "${module.vpc.vpc_id}"
  ssh_key_name = "${aws_key_pair.default.key_name}"
  subnet       = "${element(module.vpc.public_subnets, 0)}"
  public       = "true"

  // office ip
  jump_box_allowed_range        = ["193.105.212.250/32", "80.168.1.186/32"]
  jump_box_allowed_range_enable = "true"
}

resource "aws_route53_record" "jump_box" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  name    = "jump"
  type    = "A"
  ttl     = "60"
  records = ["${module.jump_box.ip_address}"]
}

output "jump_box_fqdn" {
  value = "${aws_route53_record.jump_box.fqdn}"
}
