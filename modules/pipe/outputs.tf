// KMS outputs //

output "key_arn" {
  value = "${aws_kms_key.a.arn}"
}

output "key_id" {
  value = "${aws_kms_key.a.key_id}"
}

// IAM outputs //

output "role_arn" {
  value = "${aws_iam_role.pipe_role.arn}"
}

output "role_birthday" {
  value = "${aws_iam_role.pipe_role.created_date}"
}

output "role_description" {
  value = "${aws_iam_role.pipe_role.description}"
}

output "role_id" {
  value = "${aws_iam_role.pipe_role.id}"
}

output "role_name" {
  value = "${aws_iam_role.pipe_role.name}"
}

output "role_unique_name" {
  value = "${aws_iam_role.pipe_role.unique_id}"
}

output "policy_id" {
  value = "${aws_iam_role_policy.pipe_policy.policy_id}"
}

output "policy_name" {
  value = "${aws_iam_role_policy.pipe_policy.name}"
}

output "policy_policy" {
  value = "${aws_iam_role_policy.pipe_policy.policy}"
}

output "policy_role" {
  value = "${aws_iam_role_policy.pipe_policy.role}"
}

//main (pipeline) outputs //

// Codebuild webhook outputs //

# ouptut "codebuild_webhook_id" {
#   value = "${aws_codebuild_webhook.hooky.id}"
# }
# 
# ouptut "codebuild_webhook_payload_url" {
#   value = "${aws_codebuild_webhook.hooky.payload_url}"
# }
# 
# ouptut "codebuild_webhook_seret" {
#   value = "${aws_codebuild_webhook.hooky.secret}"
# }
# 
# output "codebuild_webhook_url" {
#   value = "${aws_codebuild_webhook.hooky.url}"
# }

output "codebuild_id" {
  value = "${aws_codebuild_project.proj.id}"
}

output "codebuild_arn" {
  value = "${aws_codebuild_project.proj.arn}"
}
