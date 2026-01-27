output "iam_policy_arn" {
  description = <<-EOT
    ARN of the IAM policy that allows sending email via SES using the identity
    created by this module. Attach to an IAM role via
    `aws_iam_role_policy_attachment` to allow sending email via SES.
    EOT
  value       = aws_iam_policy.this.arn
}

output "identity_arn" {
  description = "ARN of the SES domain identity created by this module."
  value       = module.this.ses_domain_identity_arn
}
