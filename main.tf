module "this" {
  source  = "cloudposse/ses/aws"
  version = ">= 0.25.1"

  domain            = var.domain
  ses_user_enabled  = false
  ses_group_enabled = false
  verify_domain     = true
  verify_dkim       = true
  create_spf_record = true
  zone_id           = data.aws_route53_zone.domain.id

  tags = var.tags
}

resource "aws_route53_record" "dmarc" {
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 3600
  zone_id = data.aws_route53_zone.domain.id
  records = ["v=DMARC1; p=quarantine; rua=mailto:${var.dmarc_rua_mailbox}@${var.domain};"]
}

resource "aws_iam_policy" "this" {
  name        = "${var.project}-${var.environment}-ses-send"
  description = "Allows sending email via SES using the ${var.domain} domain."

  policy = jsonencode(yamldecode(templatefile("${path.module}/templates/iam-policy.yaml.tpl", {
    identity_arn = module.this.ses_domain_identity_arn
  })))

  tags = var.tags
}
