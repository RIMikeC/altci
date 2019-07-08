module "ecr" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git///modules/ecr_repositories?ref=12e6709d0c32da782e5dd2508445e4ba65ea2d77"

  repository_names    = ["dummy"]
  allowed_account_ids = ["645025723021", "190033888840", "561276803310", "665109639135"]
}
