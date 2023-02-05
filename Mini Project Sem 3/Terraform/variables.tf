variable "region" {
  default = "us-east-1"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(any)
  default = {
    Name  = "web-vpc"
  }
}

variable "ami" {
  description = "id of the machine image (AMI)"
  type        = string
  default = "ami-0574da719dca65348"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "public subnet CIDR values"
  default     = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "private subnet CIDR values"
  default     = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
}

variable "az" {
  type        = list(string)
  description = "availability zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "zone_id" {
  default = "Z03180051WW6UXMMWSMS8"
}