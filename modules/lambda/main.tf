resource "aws_iam_role" "lambda_role" {
  name = "${var.environment}-email-verification-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-email-verification-lambda-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "${var.environment}-email-verification-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Subscribe",
          "sns:Receive"
        ]
        Resource = [var.sns_topic_arn]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [var.secrets_kms_key_arn]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [var.email_credentials_arn]
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/user-verification-${var.environment}-verifyEmail"
  retention_in_days = 14

  tags = {
    Name        = "${var.environment}-email-verification-logs"
    Environment = var.environment
  }
}

resource "aws_lambda_function" "email_verification" {
  filename         = var.lambda_zip_path
  function_name    = "user-verification-${var.environment}-verifyEmail"
  role             = aws_iam_role.lambda_role.arn
  handler          = "src/handler.handler"
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  runtime          = "nodejs18.x"
  timeout          = 30

  environment {
    variables = {
      SECRETS_ARN  = var.email_credentials_arn
      DOMAIN_NAME  = "${var.environment}.${var.domain_name}"
      SENDER_EMAIL = "noreply@${var.environment}.${var.domain_name}"
    }
  }

  tags = {
    Name        = "${var.environment}-email-verification-lambda"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_verification.arn
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_verification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}