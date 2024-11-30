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

  environment           = var.environment
  vpc_id                = module.networking["main-vpc"].vpc_id
  application_port      = var.application_port
  alb_security_group_id = module.alb.security_group_id
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

  environment = var.environment
}

module "dns" {
  source = "../../modules/dns"

  environment  = var.environment
  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "iam" {
  source = "../../modules/iam"

  environment   = var.environment
  s3_bucket_arn = module.s3.bucket_arn
  sns_topic_arn = module.sns.topic_arn
}

module "alb" {
  source = "../../modules/alb"

  environment       = var.environment
  vpc_id            = module.networking["main-vpc"].vpc_id
  public_subnet_ids = module.networking["main-vpc"].public_subnet_ids
  application_port  = var.application_port
}

module "asg" {
  source = "../../modules/asg"

  environment                   = var.environment
  public_subnet_ids             = module.networking["main-vpc"].public_subnet_ids
  ami_id                        = var.ami_id
  min_size                      = var.min_size
  max_size                      = var.max_size
  desired_capacity              = var.desired_capacity
  instance_type                 = var.instance_type
  application_security_group_id = module.ec2.security_group_id
  iam_instance_profile          = module.iam.instance_profile_name
  target_group_arn              = module.alb.target_group_arn
  key_name                      = var.key_name
  scale_up_threshold            = var.scale_up_threshold
  scale_down_threshold          = var.scale_down_threshold

  user_data = base64encode(templatefile("${path.module}/user_data.tpl", {
    db_host        = split(":", module.rds.db_instance_endpoint)[0]
    db_port        = module.rds.db_instance_port
    db_name        = module.rds.db_instance_name
    db_username    = module.rds.db_instance_username
    db_password    = var.db_password
    aws_region     = var.aws_region
    s3_bucket_name = module.s3.bucket_name
    sns_topic_arn  = module.sns.topic_arn
  }))
}

module "sns" {
  source = "../../modules/sns"

  environment  = var.environment
  ec2_role_arn = module.iam.instance_role_arn
}

module "lambda" {
  source = "../../modules/lambda"

module "kms" {
  source            = "../../modules/kms"
  environment       = var.environment
  instance_role_arn = module.iam.instance_role_arn
  aws_region        = var.aws_region
}
  environment      = var.environment
  lambda_zip_path  = var.lambda_zip_path
  sendgrid_api_key = var.sendgrid_api_key
  domain_name      = var.domain_name
  sns_topic_arn    = module.sns.topic_arn
}