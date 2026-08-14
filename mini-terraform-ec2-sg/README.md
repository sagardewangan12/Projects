# Mini Terraform Project: AWS EC2 + Security Group

This Terraform project provisions:
- 1 EC2 instance
- 1 security group that allows SSH (port 22)

## Prerequisites
- Terraform >= 1.4
- AWS CLI configured (`aws configure`) or environment credentials
- An existing AWS key pair

## Files
- `main.tf` - provider, data sources, security group, and EC2 resources
- `variables.tf` - configurable inputs
- `outputs.tf` - useful output values
- `terraform.tfvars.example` - sample variable values

## Usage
```bash
cd mini-terraform-ec2-sg
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and set your key_name + allowed_ssh_cidr
terraform init
terraform plan
terraform apply
```

## Cleanup
```bash
terraform destroy
```

## Notes
- The configuration uses the default VPC and one of its default subnets.
- Restrict `allowed_ssh_cidr` to your public IP for better security.
