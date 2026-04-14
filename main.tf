module "this" {
  source  = "cloudposse/ses/aws"
  version = ">= 0.25.1"

  domain                = var.domain
  ses_user_enabled      = false
  ses_group_enabled     = false
  verify_domain         = true
  verify_dkim           = true
  create_spf_record     = true
  zone_id               = data.aws_route53_zone.domain.id
  custom_from_subdomain = [var.from_subdomain]

  tags = var.tags
}

resource "aws_ses_email_identity" "recipients" {
  for_each = toset(var.allowed_recipients)

  email = each.value
}

resource "aws_route53_record" "dmarc" {
  name    = "_dmarc.${var.domain}"
  type    = "TXT"
  ttl     = 3600
  zone_id = data.aws_route53_zone.domain.id
  records = ["v=DMARC1; p=quarantine; rua=mailto:${var.dmarc_rua_mailbox}@${var.domain};"]
}

resource "aws_sesv2_configuration_set" "this" {
  configuration_set_name = local.prefix
  tags                   = var.tags

  delivery_options {
    max_delivery_seconds = var.max_delivery_duration
    tls_policy           = var.require_tls ? "REQUIRE" : "OPTIONAL"
  }

  reputation_options {
    reputation_metrics_enabled = true
  }

  sending_options {
    sending_enabled = true
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }
}

resource "aws_sesv2_configuration_set_event_destination" "this" {
  configuration_set_name = aws_sesv2_configuration_set.this.configuration_set_name
  event_destination_name = local.prefix

  event_destination {
    enabled = true
    matching_event_types = ["BOUNCE", "COMPLAINT", "DELIVERY", "DELIVERY_DELAY",
    "REJECT", "SEND", "SUBSCRIPTION"]

    cloud_watch_destination {
      dimension_configuration {
        dimension_name          = "ses:configuration-set"
        dimension_value_source  = "MESSAGE_TAG"
        default_dimension_value = aws_sesv2_configuration_set.this.configuration_set_name
      }
    }
  }
}

resource "aws_sesv2_contact_list" "this" {
  for_each = var.create_contact_list ? toset(["this"]) : toset([])

  contact_list_name = local.prefix
  description       = "Contact list for ${var.domain}"
  tags              = var.tags

  dynamic "topic" {
    for_each = var.contact_list_topics

    content {
      topic_name                  = topic.key
      description                 = topic.value.description
      display_name                = topic.value.display_name
      default_subscription_status = topic.value.subscription_status
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = "${local.prefix}-ses-send"
  description = "Allows sending email via SES using the ${var.domain} domain."

  policy = jsonencode(yamldecode(templatefile("${path.module}/templates/iam-policy.yaml.tpl", {
    identities = concat(
      [module.this.ses_domain_identity_arn, aws_sesv2_configuration_set.this.arn],
      values(local.recipient_identities),
      var.create_contact_list ? [aws_sesv2_contact_list.this["this"].arn] : []
    )
  })))

  tags = var.tags
}
