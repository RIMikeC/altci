resource "aws_lb" "dataops_lb" {
  name               = "${var.project_name}-${var.environment}-lb"
  subnets            = ["${module.vpc.private_subnets}"]
  internal           = true
  load_balancer_type = "application"

  tags {
    "Name"         = "${var.environment}-${var.project_name}"
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
  
  security_groups = ["${aws_security_group.asg_elb.id}"]
}

resource "aws_security_group" "asg_elb" {
  name        = "${var.project_name}-${var.environment}-elb"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${module.vpc.vpc_id}"

  tags {
    Name        = "${var.project_name}-${var.environment}-elb"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "${var.lb_protocol}"

    cidr_blocks = ["${var.lb_allowed_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "dataops_lb" {
  zone_id = "${aws_route53_zone.environment.zone_id}"
  type    = "CNAME"
  name    = "${var.project_name}-elb"
  ttl     = "60"
  records = ["${aws_lb.dataops_lb.dns_name}"]
}

// Temporary Target Groups For Pentaho And Airflow EC2 Instances

resource "aws_lb_listener" "pentaho_node" {
  load_balancer_arn = "${aws_lb.dataops_lb.arn}"
  port              = "8443"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.pentaho_node.arn}"
  }
}

resource "aws_lb_listener" "airflow_node" {
  load_balancer_arn = "${aws_lb.dataops_lb.arn}"
  port              = "8453"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.airflow_node.arn}"
  }
}

resource "aws_lb_target_group" "pentaho_node" {
  name     = "pentaho-node-${var.environment}"
  port     = 8443
  protocol = "HTTPS"
  vpc_id   = "${module.vpc.vpc_id}"
}

resource "aws_lb_target_group" "airflow_node" {
  name     = "airflow-node-${var.environment}"
  port     = 8453
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}
