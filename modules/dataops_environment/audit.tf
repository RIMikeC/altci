// Audit AWS infrastructure nightly, dumping the results as objects into a bucket

module "run_nightly_audit" {
  source = "git::ssh://git@github.com/river-island/shared-lambdas.git//terraform/modules/lambda_audit_aws?ref=ee41cb461aa3fdae1fba577ac11e2c1f83114226"
}
