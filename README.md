# AWS with Terraform

## Overview
This repo contains day by day project of aws with terraform

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI with configured credentials

## Setup
```sh
git clone https://github.com/Mmuaz-pixel/terraform-aws
cd <Day-number>
terraform init
terraform apply -auto-approve
```

## Cleanup
```sh
terraform destroy -auto-approve
```

## Notes
- Modify `variables.tf` or 'terraform.tfvars' for customization.
- Adjust security groups as needed.
