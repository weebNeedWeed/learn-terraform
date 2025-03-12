# Create zone if in development. Don't create a new one if in production

resource "aws_route53_zone" "route53-zone" {
  count = var.create-dns-zone ? 1 : 0
  name  = var.domain-name
}

data "aws_route53_zone" "route53-zone" {
  count = var.create-dns-zone ? 0 : 1
  name  = var.domain-name
}

locals {
  # Because of using count, we need index 0
  dns-zone-id = var.create-dns-zone ? aws_route53_zone.route53-zone[0].zone_id : data.aws_route53_zone.route53-zone[0].zone_id
  subdomain   = var.environment-name == "production" ? "" : "${var.environment-name}."
}

resource "aws_route53_record" "www" {
  zone_id = local.dns-zone-id
  name    = "${local.subdomain}${var.domain-name}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
