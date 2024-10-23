# AWS Infrastructure as Code with Terraform

A comprehensive Infrastructure as Code (IaC) solution for deploying a multi-tier application infrastructure on AWS using Terraform. This project sets up a complete networking stack, application servers, and database infrastructure following AWS best practices.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Module Description](#module-description)
- [Configuration](#configuration)
- [Usage](#usage)
- [CI/CD Integration](#cicd-integration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

This Terraform project creates a production-ready AWS infrastructure with:
- Multi-AZ VPC setup with public and private subnets
- EC2 instances for application hosting
- RDS PostgreSQL database in private subnets
- Security groups with least-privilege access
- Proper network isolation and routing

## Architecture

```plaintext
├── VPC (10.0.0.0/16)
│   ├── Public Subnets
│   │   ├── 10.0.1.0/24 (us-east-1a)
│   │   ├── 10.0.2.0/24 (us-east-1b)
│   │   └── 10.0.3.0/24 (us-east-1c)
│   └── Private Subnets
│       ├── 10.0.4.0/24 (us-east-1a)
│       ├── 10.0.5.0/24 (us-east-1b)
│       └── 10.0.6.0/24 (us-east-1c)
├── EC2 Instances
│   └── Application Server (t2.small)
└── RDS
    └── PostgreSQL Database (db.t3.medium)
```

## Prerequisites

- Terraform >= 1.9.0
- AWS CLI configured with appropriate credentials
- Access to AWS account with necessary permissions

## Directory Structure

```
tf-aws-infra/
├── environments/
│   └── dev/
│       ├── main.tf         # Main configuration
│       ├── variables.tf    # Variable definitions
│       ├── terraform.tfvars # Variable values
│       └── outputs.tf      # Output definitions
├── modules/
│   ├── networking/        # VPC and network resources
│   ├── ec2/              # EC2 instance resources
│   └── rds/              # RDS instance resources
└── .github/
    └── workflows/         # CI/CD configurations
```

## Module Description

### Networking Module
- Creates VPC with specified CIDR block
- Sets up public and private subnets across multiple AZs
- Configures Internet Gateway and route tables
- Implements network ACLs and security groups

### EC2 Module
- Launches application instances in public subnets
- Configures security groups for application access
- Sets up instance profiles and IAM roles
- Manages user data for instance configuration

### RDS Module
- Deploys PostgreSQL RDS instance in private subnets
- Configures database security groups
- Sets up parameter groups and subnet groups
- Manages backup and maintenance windows

## Configuration

1. Create a `terraform.tfvars` file in your environment directory:
```hcl
aws_region  = "us-east-1"
environment = "dev"

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

vpcs = {
  main-vpc = {
    cidr_block           = "10.0.0.0/16"
    public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  },
  # vpc2 = {
  #   cidr_block           = "10.1.0.0/16"
  #   public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  #   private_subnet_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  # }
}

ami_id                    = "ami-0f448c9764a39658f"
instance_type             = "t2.small"
application_port          = 3000
database_port             = 5432
db_parameter_group_family = "postgres14"
db_engine                 = "postgres"
db_engine_version         = "14.13" # or your preferred version
db_instance_class         = "db.t3.medium"
db_name                   = "your_db_name"
db_username               = "your_db_username"
db_password               = "your_db_password"
```

## Usage

1. Move to the dev directory:
```bash
cd environments/dev
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the plan:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

## CI/CD Integration

The project includes GitHub Actions workflows for:
- Terraform format checking
- Configuration validation
- Infrastructure deployment
- Security scanning

## Best Practices

1. **State Management**
   - Use remote state storage
   - Enable state locking
   - Implement state encryption

2. **Security**
   - Implement least privilege access
   - Use security groups effectively
   - Encrypt sensitive data

3. **Networking**
   - Implement proper subnet sizing
   - Use proper CIDR block allocation
   - Configure route tables correctly

## Troubleshooting

Common issues and solutions:
1. **Subnet Issues**
   - Ensure CIDR blocks don't overlap
   - Verify AZ availability

2. **Security Group Problems**
   - Check ingress/egress rules
   - Verify security group references

3. **RDS Connectivity**
   - Confirm subnet group configuration
   - Verify security group rules
