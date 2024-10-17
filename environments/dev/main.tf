terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0, <6.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source   = "../../modules/networking"
  for_each = var.vpcs

  vpc_cidr             = each.value.cidr_block
  public_subnet_cidrs  = each.value.public_subnet_cidrs
  private_subnet_cidrs = each.value.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
  vpc_name             = each.key
}

module "ec2" {
  source = "../../modules/ec2"

  environment      = var.environment
  vpc_id           = module.networking["main-vpc"].vpc_id
  subnet_id        = module.networking["main-vpc"].public_subnet_ids[0]
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  application_port = var.application_port
}