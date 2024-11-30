data "aws_acm_certificate" "existing" {
  domain      = "${var.environment}.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}