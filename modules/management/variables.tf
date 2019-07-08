variable "project_name" {
  type        = "string"
  description = "name of our project"
  default     = "dataops"
}

variable "environment" {
  type        = "string"
  description = "environment"
  default     = "management"
}

// concourse_ci.tf variables

variable "module_instance_id" {
  type        = "string"
  description = "Use this to create unique resource names"
  default     = "0"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
  default     = ["10.202.184.0/24", "10.202.185.0/24", "10.202.186.0/24"]
}

variable "public_subnets" {
  type        = "list"
  description = "public subnet cidrs"
  default     = ["10.202.187.0/24", "10.202.188.0/24", "10.202.189.0/24"]
}

variable "vpc_cidr" {
  type        = "string"
  description = "describe your variable"
  default     = "10.202.184.0/21"
}

variable "aws_ssh_key_file" {
  type        = "string"
  description = "name of the ssh key file stored in the aws account folder"
  default     = "default"
}

// vpc_peering - dev transit
variable "dev_transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the dev transit vpc sits in"
  default     = "556748783639"
}

variable "dev_transit_vpc_id" {
  type        = "string"
  description = "the id of the dev transit vpc that has the direct connect connection attached"
  default     = "vpc-2ee35b4a"
}

variable "dev_transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc dev subnet to route to"
  default     = "10.201.0.0/16"
}

// vpc_peering.tf - prod transit
variable "transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
  default     = "376076567968"
}

variable "transit_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
  default     = "vpc-2efefe4a"
}

variable "transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
  default     = "10.202.0.0/22"
}

variable "region" {
  description = "The region the AWS resources will run in"
  default     = "eu-west-1"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "t2.micro"
}

variable "dynamodb_read_capacity" {
  type        = "string"
  description = "arn of the KMS key used to encrypt the TLS assets"
  default     = "10"
}

variable "dynamodb_write_capacity" {
  type        = "string"
  description = "arn of the KMS key used to encrypt the TLS assets"
  default     = "5"
}

variable "database_subnets" {
  type        = "list"
  description = "A list of database subnets"
  default     = []
}

variable "elasticache_subnets" {
  type        = "list"
  description = "A list of elasticache subnets"
  default     = []
}
