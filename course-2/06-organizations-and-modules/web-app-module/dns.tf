resource "aws_route53_zone" "route53-zone" {
  name = var.domain-name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.route53-zone.id
  name    = format("www.%s", var.domain-name)
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
