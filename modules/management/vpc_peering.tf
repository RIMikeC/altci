// VPC peering to the transit VPC
resource "aws_vpc_peering_connection" "transit_vpc" {
  peer_owner_id = "${var.transit_vpc_account_id}"
  peer_vpc_id   = "${var.transit_vpc_id}"
  vpc_id        = "${module.vpc.vpc_id}"

  tags {
    "Name"         = "${var.project_name}-${var.environment}"
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

resource "aws_route" "transit_vpc" {
  route_table_id            = "${element(module.vpc.private_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.transit_vpc_subnet_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.transit_vpc.id}"
  count                     = "${length(var.private_subnets)}"
}

output "management_to_prod_vpc_peering_connection_id" {
  value = "${aws_vpc_peering_connection.transit_vpc.id}"
}
