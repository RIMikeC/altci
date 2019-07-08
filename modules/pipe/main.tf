# This code creates pipeline for delivering infra built using Terraform.

# # resource "aws_codebuild_webhook" "hooky" {
#   project_name = "${aws_codebuild_project.proj.name}"
# }
# 
# resource "github_repository_webhook" "webhooky" {
#   active     = true
#   events     = ["push"]
#   name       = "
#   repository = "
# 
#   configuration {
#     url          = "${aws_codebuild_webhook.proj.payload_url}"
#     secret       = "${aws_codebuild_webhook.proj.secret}"
#     content_type = "json"
#     insecure_ssl = false
#   }
# }

resource "aws_codebuild_project" "proj" {
  name = "${var.codebuild_name}"

  artifacts {
    type                = "S3"
    encryption_disabled = true                 # This is just to make development quicker and debugging easier, it will be changed to false later
    location            = "${var.bucket_name}"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/python:3.6.5"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type = "GITHUB"

    auth {
      type     = "OATH"
      resource = "ploppy"
    }

    location            = "https://github.com/River-Island/dataops-terraform/tree/master"
    git_clone_depth     = 1
    report_build_status = true
    buildspec           = "${file("${path.module}/../../alt_ci/${environment}_buildspec.yml")}"
  }

  build_timeout = 10

  cache {
    type = "NO_CACHE"
  }

  description = "${var.codebuild_description}"

  #  encryption_key = "${aws_kms_key.a.key_id}"
  service_role = "${aws_iam_role.pipe_role.arn}"
  tags         = "${var.tags}"

  vpc_config = {
    security_group_ids = ["${var.security_groups}"]
    subnets            = ["${var.subnets}"]
    vpc_id             = "${var.vpc_id}"
  }

  secondary_artifacts {}

  secondary_sources {}
}
