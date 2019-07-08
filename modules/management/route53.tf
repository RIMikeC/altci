resource "aws_route53_zone" "environment" {
  #Environment subdomain truncated to keep it under the DNS character limit
  name = "${var.environment}.${var.project_name}.ri-tech.io"

  tags {
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

output "route53_name_servers" {
  value = "${aws_route53_zone.environment.name_servers}"
}
