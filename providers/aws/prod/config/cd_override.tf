terraform {
  backend "s3" {
    bucket   = "prod-dataops-tf-state"
    key      = "infrastructure/terraform.tfstate"
    region   = "eu-west-1"
    role_arn = "arn:aws:iam::665109639135:role/cd"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "1.30.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["665109639135"]

  assume_role {
    role_arn = "arn:aws:iam::665109639135:role/cd"
  }
}
