output "configuration_set_name" {
  description = "Name of the created SES configuration set."
  value       = aws_sesv2_configuration_set.this.configuration_set_name
}

output "contact_list_name" {
  description = "Name of the created SES contact list."
  value       = var.create_contact_list ? aws_sesv2_contact_list.this["this"].contact_list_name : null
}

output "contact_list_topics" {
  description = "Topics created for the contact list."
  value       = var.create_contact_list ? keys(var.contact_list_topics) : null
}

output "iam_policy_arn" {
  description = <<-EOT
    ARN of the IAM policy that allows sending email via SES using the identity
    created by this module. Attach to an IAM role via
    `aws_iam_role_policy_attachment` to allow sending email via SES.
    EOT
  value       = aws_iam_policy.this.arn
}

output "identity_arn" {
  description = "ARN of the created SES domain identity."
  value       = module.this.ses_domain_identity_arn
}

output "recipient_identities" {
  description = <<-EOT
    ARNs of the SES email identities created for allowed recipients.
    EOT
  value       = local.recipient_identities
}
