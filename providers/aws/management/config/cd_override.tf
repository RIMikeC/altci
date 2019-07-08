terraform {
  backend "s3" {
    bucket   = "management-dataops-tf-state"
    key      = "infrastructure/terraform.tfstate"
    region   = "eu-west-1"
    role_arn = "arn:aws:iam::645025723021:role/cd"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.29.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["645025723021"]

  assume_role {
    role_arn = "arn:aws:iam::645025723021:role/cd"
  }
}
