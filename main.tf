module "this" {
  source  = "cloudposse/ses/aws"
  version = ">= 0.25.1"

  domain            = var.domain
  ses_user_enabled  = false
  ses_group_enabled = false
  verify_domain     = true
  verify_dkim       = true
  zone_id           = data.aws_route53_zone.domain.id

  tags = var.tags
}
