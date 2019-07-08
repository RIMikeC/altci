variable "codebuild_name" {
  description = "Name of the pipline to create"
  type        = "string"
}

variable "codebuild_description" {
  description = "Description of the pipline"
  type        = "string"
}

variable "tags" {
  description = "Tags for all resources"
  type        = "map"
}

variable "bucket_name" {
  description = "Store for build artifacts"
}

variable "security_groups" {
  description = "security groups"
  type        = "list"
}

variable "subnets" {
  description = "security groups"
  type        = "list"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}
