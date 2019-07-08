variable "project_name" {
  type        = "string"
  description = "name of our project"
  default     = "dataops"
}

variable "environment" {
  type        = "string"
  description = "environment"
  default     = "dev"
}

variable "module_instance_id" {
  type        = "string"
  description = "Use this to create unique resource names"
  default     = "0"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
  default     = ["10.200.200.0/24", "10.200.201.0/24", "10.200.202.0/24"]
}

variable "public_subnets" {
  type        = "list"
  description = "public subnet cidrs"
  default     = ["10.200.203.0/24", "10.200.204.0/24", "10.200.205.0/24"]
}

variable "vpc_cidr" {
  type        = "string"
  description = "describe your variable"
  default     = "10.200.200.0/21"
}

variable "aws_ssh_key_file" {
  default = "default"
}

// transit vpc peering setup
variable "transit_vpc_peering" {
  description = "Peer to the transit vpc in another account"
  default     = true
}

variable "transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
}

variable "transit_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
}

variable "transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
}

variable "availability_zones" {
  description = "Availability zones to place the private/public subnets in"
  default     = ["eu-west-1a", "eu-west-1b"]
  type        = "list"
}

variable "lb_allowed_cidr_blocks" {
  description = "list of allowed IPs on the LB created"
  default     = ["10.0.0.0/8"]
}

variable "lb_protocol" {
  description = "The lb protocol eg tcp"
  default     = "tcp"
}
