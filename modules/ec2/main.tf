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

resource "aws_vpc_security_group_ingress_rule" "application" {
  security_group_id            = aws_security_group.application.id
  description                  = "Allow application port access"
  from_port                    = var.application_port
  to_port                      = var.application_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.alb_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.application.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}