# AWS Infrastructure as Code with Terraform

A comprehensive Infrastructure as Code (IaC) solution for deploying a multi-tier application infrastructure on AWS using Terraform. This project sets up a complete networking stack, auto-scaling application servers, load balancer, database infrastructure, and S3 storage following AWS best practices.

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
- Application Load Balancer (ALB) for traffic distribution
- Auto Scaling Group for EC2 instances
- RDS PostgreSQL database in private subnets
- S3 bucket for application storage
- Route 53 DNS configuration
- IAM roles and policies
- Security groups with least-privilege access
- Proper network isolation and routing
- CloudWatch monitoring and auto-scaling policies

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
├── Application Load Balancer
├── Auto Scaling Group
│   └── EC2 Instances (t2.small)
├── RDS
│   └── PostgreSQL Database (db.t3.medium)
└── S3 Bucket
```

## Prerequisites

- Terraform >= 1.9.0
- AWS CLI configured with appropriate credentials
- Access to AWS account with necessary permissions
- Domain name configured in Route 53 (for DNS configuration)

## Directory Structure

```
tf-aws-infra/
├── environments/
│   └── dev/
│       ├── main.tf          # Main configuration
│       ├── variables.tf     # Variable definitions
│       ├── terraform.tfvars # Variable values
│       ├── outputs.tf       # Output definitions
│       └── user_data.tpl    # EC2 instance user data template
├── modules/
│   ├── networking/          # VPC and network resources
│   ├── ec2/                 # EC2 security groups
│   ├── rds/                 # RDS instance resources
│   ├── s3/                  # S3 bucket configuration
│   ├── iam/                 # IAM roles and policies
│   ├── alb/                 # Application Load Balancer
│   ├── asg/                 # Auto Scaling Group
│   └── dns/                 # Route 53 configuration
└── .github/
    └── workflows/           # CI/CD configurations
```

## Module Description

### Networking Module
- Creates VPC with specified CIDR block
- Sets up public and private subnets across multiple AZs
- Configures Internet Gateway and route tables
- Implements network ACLs and security groups

### ALB Module
- Configures Application Load Balancer in public subnets
- Sets up target groups and listeners
- Manages health checks and routing rules
- Configures security groups for load balancer access

### ASG Module
- Manages Auto Scaling Group configuration
- Configures launch templates for EC2 instances
- Sets up scaling policies based on CPU utilization
- Configures CloudWatch alarms for scaling triggers

### EC2 Module
- Configures security groups for application access
- Manages inbound and outbound traffic rules
- Coordinates with ALB security group

### RDS Module
- Deploys PostgreSQL RDS instance in private subnets
- Configures database security groups
- Sets up parameter groups and subnet groups
- Manages backup and maintenance windows

### S3 Module
- Creates S3 bucket with unique name
- Configures bucket encryption
- Sets up lifecycle policies
- Blocks public access

### IAM Module
- Creates IAM roles for EC2 instances
- Sets up policies for CloudWatch and S3 access
- Configures instance profiles

### DNS Module
- Configures Route 53 records
- Sets up ALB alias records
- Manages domain routing

## Configuration

1. Create a `terraform.tfvars` file in your environment directory:

```hcl
# Region and Environment Settings
# -----------------------------
aws_region  = "us-east-1"        # AWS region where resources will be created
environment = "dev"              # Environment name (dev, staging, prod, etc.)

# Domain Configuration
# ------------------
domain_name = "example.com"      # Your registered domain name

# Availability Zones
# ----------------
# List of AZs in the selected region where resources will be distributed
availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

# VPC Configuration
# ---------------
# Define one or more VPCs with their CIDR blocks and subnet ranges
vpcs = {
  main-vpc = {
    cidr_block           = "10.0.0.0/16"    # Main VPC CIDR block
    public_subnet_cidrs  = [                # Public subnet CIDR blocks
      "10.0.1.0/24",    # us-east-1a
      "10.0.2.0/24",    # us-east-1b
      "10.0.3.0/24"     # us-east-1c
    ]
    private_subnet_cidrs = [                # Private subnet CIDR blocks
      "10.0.4.0/24",    # us-east-1a
      "10.0.5.0/24",    # us-east-1b
      "10.0.6.0/24"     # us-east-1c
    ]
  }
  # Uncomment and modify for additional VPCs
  # vpc2 = {
  #   cidr_block           = "10.1.0.0/16"
  #   public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  #   private_subnet_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  # }
}

# EC2 Configuration
# ---------------
ami_id           = "ami-example"         # AMI ID (update as needed)
instance_type    = "t2.small"            # EC2 instance type
application_port = 3000                  # Application port number
key_name         = "your-ssh-key-name"   # SSH key pair name

# Auto Scaling Configuration
# -----------------------
min_size             = 3                     # Minimum number of EC2 instances
max_size             = 5                     # Maximum number of EC2 instances
desired_capacity     = 3                     # Desired number of EC2 instances
scale_up_threshold   = "5"                   # CPU percentage to trigger scale up
scale_down_threshold = "3"                   # CPU percentage to trigger scale down

# Database Configuration
# -------------------
database_port             = 5432                # PostgreSQL port
db_parameter_group_family = "postgres14"        # DB parameter group family
db_engine                 = "postgres"          # Database engine
db_engine_version         = "14.13"             # Database engine version
db_instance_class         = "db.t3.medium"      # RDS instance type
db_name                   = "your_db_name"      # Database name
db_username               = "your_db_username"  # Database master username
db_password               = "your_db_password"  # Database master password
```

### Important Configuration Notes

1. **Sensitive Information**:
   - In production, avoid storing sensitive values like `db_password` directly in tfvars
   - Use AWS Secrets Manager, SSM Parameter Store, or environment variables
   - Consider using Terraform workspaces for environment separation

2. **AMI ID**:
   - AMI IDs are region-specific
   - Verify the AMI ID exists in your chosen region
   - Consider using SSM Parameter Store for AMI IDs to auto-update

3. **Instance Types**:
   - Choose instance types based on your application requirements
   - Consider using spot instances for non-production environments
   - Balance cost vs performance needs

4. **Auto Scaling**:
   - Adjust min/max/desired capacity based on your application needs
   - Set appropriate scaling thresholds based on application behavior
   - Consider time-based scaling for predictable load patterns

5. **Database**:
   - Choose appropriate instance class based on workload
   - Consider multi-AZ deployment for production
   - Use appropriate parameter group settings

6. **Networking**:
   - Ensure CIDR blocks don't overlap
   - Plan subnet sizes based on expected growth
   - Consider future networking needs

7. **Security**:
   - Use strong passwords
   - Implement proper key rotation
   - Follow least privilege principle
   - Enable encryption where possible

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
   - Keep secrets in secure storage

3. **High Availability**
   - Deploy across multiple AZs
   - Use Auto Scaling Groups
   - Implement proper health checks
   - Configure proper backup policies

4. **Monitoring**
   - Set up CloudWatch alarms
   - Configure proper scaling policies
   - Monitor application metrics
   - Set up logging

## Troubleshooting

Common issues and solutions:

1. **Load Balancer Issues**
   - Verify target group health checks
   - Check security group configurations
   - Validate listener rules

2. **Auto Scaling Issues**
   - Verify launch template configuration
   - Check CloudWatch alarms
   - Validate scaling policies
   - Monitor instance health

3. **Database Connectivity**
   - Confirm subnet group configuration
   - Verify security group rules
   - Check network routing

4. **DNS Issues**
   - Verify Route 53 record configuration
   - Check ALB DNS name
   - Validate domain settings