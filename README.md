# AWS Infrastructure as Code with Terraform

A comprehensive Infrastructure as Code (IaC) solution for deploying a multi-tier application infrastructure on AWS using Terraform. This project sets up a complete networking stack, auto-scaling application servers, load balancer, database infrastructure, and S3 storage following AWS best practices.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Module Description](#module-description)
- [Infrastructure Components](#infrastructure-components)
- [Configuration](#configuration)
- [Usage](#usage)
- [CI/CD Integration](#cicd-integration)
- [Best Practices](#best-practices)

## Overview

This Terraform project creates a production-ready AWS infrastructure with:
- Multi-AZ VPC setup with public and private subnets
- Application Load Balancer (ALB) for traffic distribution
- Auto Scaling Group with customizable scaling policies
- RDS PostgreSQL database in private subnets
- S3 bucket for application assets
- SNS topic for user verification emails
- Lambda function for email processing
- Route 53 DNS configuration
- IAM roles with least-privilege access
- CloudWatch monitoring and metrics collection

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
├── RDS PostgreSQL (db.t3.medium)
├── S3 Bucket
├── SNS Topic
└── Lambda Function
```

## Prerequisites

- Terraform >= 1.9.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions
- Domain name configured in Route 53
- SendGrid API key for email notifications

## Directory Structure

```
.
├── environments/
│   └── dev/
│       ├── main.tf           # Main configuration
│       ├── variables.tf      # Variable definitions
│       ├── terraform.tfvars  # Variable values
│       ├── outputs.tf        # Output definitions
│       └── user_data.tpl     # EC2 user data template
└── modules/
    ├── networking/           # VPC and network resources
    ├── ec2/                  # EC2 security groups
    ├── rds/                  # RDS instance and configuration
    ├── s3/                   # S3 bucket with lifecycle policies
    ├── iam/                  # IAM roles and policies
    ├── alb/                  # Application Load Balancer
    ├── asg/                  # Auto Scaling Group
    ├── sns/                  # SNS topic for notifications
    ├── lambda/               # Lambda function configuration
    └── dns/                  # Route 53 configuration
```

## Module Description

### Networking Module
- Creates VPC with configurable CIDR block
- Sets up public and private subnets across multiple AZs
- Configures Internet Gateway and routing
- Implements network isolation

### ALB Module
- Configures Application Load Balancer in public subnets
- Implements health checks and routing rules
- Manages security groups for load balancer access
- Supports HTTP traffic on port 80

### ASG Module
- Manages Auto Scaling Group with configurable capacity
- Configures launch templates for EC2 instances
- Implements CPU-based scaling policies
- Sets up CloudWatch alarms for scaling triggers

### RDS Module
- Deploys PostgreSQL RDS instance in private subnets
- Configures security groups for database access
- Manages parameter groups and subnet groups
- Supports automated backups

### S3 Module
- Creates S3 bucket with encryption
- Implements lifecycle policies
- Blocks public access
- Configures server-side encryption

### IAM Module
- Creates EC2 instance roles
- Configures policies for CloudWatch, S3, and SNS access
- Implements least-privilege access

### SNS Module
- Creates topic for user verification emails
- Configures access policies
- Integrates with Lambda function

### Lambda Module
- Deploys email verification function
- Configures SendGrid integration
- Manages CloudWatch logs
- Sets up SNS trigger

## Infrastructure Components

### Auto Scaling Configuration
- Minimum instances: 3
- Maximum instances: 5
- Scale up threshold: 5% CPU utilization
- Scale down threshold: 3% CPU utilization
- Instance type: t2.small

### Database Configuration
- Engine: PostgreSQL 14.13
- Instance class: db.t3.medium
- Storage: GP2 (General Purpose SSD)
- Multi-AZ: Disabled
- Automated backups: Enabled

## Configuration

Create a `terraform.tfvars` file in your environment directory with the following structure:

```hcl
# Region and Environment
aws_region  = "us-east-1"
environment = "dev"

# Domain Configuration
domain_name = "your-domain.com"

# Availability Zones
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# VPC Configuration
vpcs = {
  main-vpc = {
    cidr_block           = "10.0.0.0/16"
    public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }
}

# EC2 Configuration
ami_id           = "ami-xxxxxxxx"
instance_type    = "t2.small"
application_port = 3000
key_name         = "your-ssh-key"

# Auto Scaling Configuration
min_size             = 3
max_size             = 5
desired_capacity     = 3
scale_up_threshold   = "5"
scale_down_threshold = "3"

# Database Configuration
database_port             = 5432
db_parameter_group_family = "postgres14"
db_engine                = "postgres"
db_engine_version        = "14.13"
db_instance_class        = "db.t3.medium"
db_name                  = "your_database_name"
db_username              = "your_username"
db_password              = "your_password"

# Email Configuration
sendgrid_api_key = "your-sendgrid-api-key"
lambda_zip_path  = "path-to-your-lambda-zip-file"
```

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

4. To destroy the infrastructure:
```bash
terraform destroy
```

> **Note**: Always review the plan output before applying changes to production infrastructure.

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