resource "aws_security_group" "database" {
  name = "${var.environment}-database-sg"
  description = "Security group for RDS instances"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.environment}-database-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "database" {
  security_group_id = aws_security_group.database.id
  description =  "Allow database port access from application security group"
  from_port         = var.database_port
  ip_protocol       = "tcp"
  to_port           = var.database_port
  referenced_security_group_id = var.application_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.database.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
