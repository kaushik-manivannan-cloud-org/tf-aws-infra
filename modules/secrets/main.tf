# Generate random password for RDS
resource "random_password" "db_password" {
  length           = 16
  special          = true
  min_special      = 2
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

# Database credentials secret
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.environment}-database-credentials-${formatdate("YYYYMMDD", timestamp())}"
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = 0

  tags = {
    Name        = "${var.environment}-db-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

# Email service credentials secret
resource "aws_secretsmanager_secret" "email_credentials" {
  name                    = "${var.environment}-email-credentials-${formatdate("YYYYMMDD", timestamp())}"
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = 0

  tags = {
    Name        = "${var.environment}-email-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "email_credentials" {
  secret_id = aws_secretsmanager_secret.email_credentials.id
  secret_string = jsonencode({
    sendgrid_api_key = var.sendgrid_api_key
  })
}

