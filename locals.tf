locals {
  prefix = join("-", [var.project, var.environment])
  recipient_identities = {
    for identity in aws_ses_email_identity.recipients : identity.email => identity.arn
  }
}
