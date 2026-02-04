data "aws_region" "current" {}

data "aws_route53_zone" "domain" {
  name    = var.hosted_zone_id != null ? null : var.domain
  zone_id = var.hosted_zone_id
}
