# This file contains the terraform configuration to create an RDS instance
# The RDS instance is created in the VPC created by the networking module

# Security group for the RDS instance
resource "aws_security_group" "database" {
  name        = "${var.environment}-database-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-database-sg"
    Environment = var.environment
  }
}

# Ingress rule to allow traffic from the application security group
resource "aws_vpc_security_group_ingress_rule" "database" {
  security_group_id            = aws_security_group.database.id
  description                  = "Allow database port access from application security group"
  from_port                    = var.database_port
  ip_protocol                  = "tcp"
  to_port                      = var.database_port
  referenced_security_group_id = var.application_security_group_id
}

# Egress rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.database.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# DB parameter group
resource "aws_db_parameter_group" "database" {
  name        = "${var.environment}-database-pg"
  family      = var.db_parameter_group_family
  description = "Parameter group for RDS instances"

  tags = {
    Name        = "${var.environment}-database-pg"
    Environment = var.environment
  }

  # You can add other PostgreSQL-specific parameters here if needed
  # For example:
  # parameter {
  #   name  = "max_connections"
  #   value = "100"
  # }
}

# DB subnet group
resource "aws_db_subnet_group" "database" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS instance
resource "aws_db_instance" "database" {
  identifier = "csye6225"

  # Engine Configuration
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  port           = var.database_port

  # Storage Configuration
  allocated_storage = 10
  storage_type      = "gp2"

  # Database Configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Network Configuration
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false

  # Parameter Group
  parameter_group_name = aws_db_parameter_group.database.name

  # Backup and Maintenance
  multi_az            = false
  skip_final_snapshot = true

  tags = {
    Name        = "${var.environment}-database"
    Environment = var.environment
  }
}

