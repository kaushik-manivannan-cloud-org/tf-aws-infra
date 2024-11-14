resource "aws_sns_topic" "user_verification" {
  name         = "user-verification"
  display_name = "User Verification Notifications"

  tags = {
    Name        = "${var.environment}-user-verification-topic"
    Environment = var.environment
  }
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.user_verification.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.environment}-user-verification-topic-policy"
    Statement = [
      {
        Sid    = "AllowEC2ToPublish"
        Effect = "Allow"
        Principal = {
          AWS = var.ec2_role_arn
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.user_verification.arn
      }
    ]
  })
}