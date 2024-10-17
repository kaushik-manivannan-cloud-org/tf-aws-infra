resource "aws_security_group" "application" {
  name        = "${var.environment}-application-sg"
  description = "Security group for web application"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-application-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.application.id
  description       = "Allow SSH access"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.application.id
  description       = "Allow HTTP access"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.application.id
  description       = "Allow HTTPS access"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "application" {
  security_group_id = aws_security_group.application.id
  description       = "Allow application port access"
  from_port         = var.application_port
  to_port           = var.application_port
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.application.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.application.id]

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  disable_api_termination = false

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
  }
}