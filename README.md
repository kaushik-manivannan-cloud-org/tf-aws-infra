# AWS Infrastructure with Terraform

This project uses Terraform to set up AWS networking infrastructure, including VPCs, subnets, internet gateways, and route tables.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version 1.9.0 or later)
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured with appropriate credentials
- An AWS account with necessary permissions to create networking resources

## Configuration

1. Clone this repository:
   ```
   git clone https://github.com/kaushik-manivannan/tf-aws-infra.git
   cd tf-aws-infra
   ```

2. Navigate to the environment you want to work with:
   ```
   cd environments/dev
   ```

3. Update the `terraform.tfvars` file with your desired configuration:
   ```hcl
   aws_region  = "us-east-1"
   environment = "dev"

   vpcs = {
     vpc1 = {
       cidr_block           = "10.0.0.0/16"
       public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
       private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
     }
   }
   ```

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Preview the changes:
   ```
   terraform plan
   ```

3. Apply the changes:
   ```
   terraform apply
   ```

4. When prompted, type `yes` to confirm and create the resources.

## Adding or Modifying VPCs

To add or modify VPCs, update the `vpcs` map in the `terraform.tfvars` file. For example, to add a second VPC:

```hcl
vpcs = {
  vpc1 = { ... },
  vpc2 = {
    cidr_block           = "10.1.0.0/16"
    public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    private_subnet_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  }
}
```

After modifying the `terraform.tfvars` file, run `terraform plan` and `terraform apply` to implement the changes.

## Outputs

After applying the Terraform configuration, you'll see outputs including:

- VPC IDs
- Subnet IDs
- Internet Gateway IDs
- Route Table IDs

These outputs are helpful for reference and for use in other parts of your infrastructure.

## Terraform Commands

- `terraform init`: Initialize the Terraform working directory
- `terraform plan`: Preview changes
- `terraform apply`: Apply changes
- `terraform destroy`: Destroy all created resources (use with caution)
- `terraform output`: View all outputs
- `terraform show`: Show the current state of the infrastructure

## Troubleshooting

- If you encounter errors related to AWS credentials, ensure your AWS CLI is correctly configured.
- For "resource already exists" errors, make sure you're not trying to create resources that already exist in your AWS account.
- If Terraform seems stuck or frozen, check your internet connection and AWS console for any ongoing operations.

For more help, consult the [Terraform documentation](https://www.terraform.io/docs/index.html) or open an issue in this repository.