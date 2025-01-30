# AWS Infrastructure with Terraform

## Overview
This Terraform project sets up an AWS VPC with private subnets, a NAT Gateway, a Load Balancer, EC2 instances, and an S3 bucket.

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI with configured credentials

## Setup
```sh
git clone https://github.com/Mmuaz-pixel/terraform-aws
cd terraform-aws-infra
terraform init
terraform apply -auto-approve
```

## Resources
- **VPC** (CIDR `172.16.0.0/16`)
- **Private Subnets** (`172.16.1.0/24`, `172.16.2.0/24`)
- **NAT Gateway** for outbound internet access
- **Load Balancer** for traffic distribution
- **EC2 Instances** in private subnets
- **Amazon S3** for storage

## Cleanup
```sh
terraform destroy -auto-approve
```

## Notes
- Modify `variables.tf` for customization.
- Adjust security groups as needed.
