variable "region" {
  description = "The AWS region to launch resources"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  description = "The CIDR block for the first subnet"
  default     = "10.0.0.0/24"
}

variable "subnet1_availability_zone" {
  description = "The availability zone for the first subnet"
  default     = "us-east-1a"
}

variable "subnet2_cidr_block" {
  description = "The CIDR block for the first subnet"
  default     = "10.0.1.0/24"
}

variable "subnet2_availability_zone" {
  description = "The availability zone for the first subnet"
  default     = "us-east-1b"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  default     = "terraform-bucket-day1"
}
