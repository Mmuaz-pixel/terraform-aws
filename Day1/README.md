# AWS Infrastructure with Terraform

## Overview
This Terraform project sets up an AWS VPC with public subnets, a internet Gateway, a Load Balancer, EC2 instances, and an S3 bucket.

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI with configured credentials

## Setup
```sh
git clone https://github.com/Mmuaz-pixel/terraform-aws
cd Day1
terraform init
terraform apply -auto-approve
```

## Resources
- **VPC** 
- **Public Subnets** 
- **Internet Gateway** for outbound internet access
- **Load Balancer** for traffic distribution
- **EC2 Instances** in subnets
- **Amazon S3** for storage

## Cleanup
```sh
terraform destroy -auto-approve
```

## Notes
- Modify `variables.tf` for customization.
- Adjust security groups as needed.
