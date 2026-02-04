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
