terraform {
  backend "s3" {
    bucket  = "k8s.dev.dataops.ri-tech.io"
    key     = "altdev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = false
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

module "altdev" {
  source                = "../../../modules/pipe"
  codebuild_name        = "tf_fmt"
  codebuild_description = "Terraform format"
  bucket_name           = "k8s.dev.dataops.ri-tech.io"

  tags {
    environment = "dev"
    owner       = "mikec"
  }

  security_groups = ["sg-0be41f69ebd6bc70c"]
  subnets         = ["subnet-06c68c65cba594158", "subnet-0a9246aeff2fd7727", "subnet-0a9246aeff2fd7727"]
  vpc_id          = "vpc-064d76f52de6ddc92"
}
