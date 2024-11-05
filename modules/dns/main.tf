data "aws_route53_zone" "selected" {
  name         = "${var.environment}.${var.domain_name}"
  private_zone = false
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}