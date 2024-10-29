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
  user_data = base64encode(templatefile("${path.module}/user_data.tpl", {
    db_host     = split(":", module.rds.db_instance_endpoint)[0]
    db_port     = module.rds.db_instance_port
    db_name     = module.rds.db_instance_name
    db_username = module.rds.db_instance_username
    db_password = var.db_password
  }))
}

module "rds" {
  source = "../../modules/rds"

  environment                   = var.environment
  vpc_id                        = module.networking["main-vpc"].vpc_id
  database_port                 = var.database_port
  application_security_group_id = module.ec2.security_group_id
  db_parameter_group_family     = var.db_parameter_group_family
  private_subnet_ids            = module.networking["main-vpc"].private_subnet_ids
  db_engine                     = var.db_engine
  db_engine_version             = var.db_engine_version
  db_instance_class             = var.db_instance_class
  db_name                       = var.db_name
  db_username                   = var.db_username
  db_password                   = var.db_password
}

module "s3" {
  source = "../../modules/s3"

  environment                   = var.environment
}

module "dns" {
  source = "../../modules/dns"

  instance_public_ip = module.ec2.instance_public_ip
  environment = var.environment
  domain_name = var.domain_name
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment
  s3_bucket_arn = module.s3.bucket_arn
}