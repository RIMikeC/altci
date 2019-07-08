terraform {
  backend "s3" {
    bucket   = "staging-dataops-tf-state"
    key      = "infrastructure/terraform.tfstate"
    region   = "eu-west-1"
    role_arn = "arn:aws:iam::561276803310:role/cd"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.30.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["561276803310"]

  assume_role {
    role_arn = "arn:aws:iam::561276803310:role/cd"
  }
}
