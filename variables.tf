variable "allowed_recipients" {
  type        = list(string)
  description = <<-EOT
    List of email addresses to create identities for, allowing them to receive
    email from the domain. This is required in order for recipients to receive
    email from the domain while in sandbox mode.
    EOT
  default     = []
}

variable "create_contact_list" {
  type        = bool
  description = <<-EOT
    Whether to create a contact list to manage subscriptions for the domain.
    EOT
  default     = true
}

variable "contact_list_topics" {
  type = map(object({
    description         = optional(string, "")
    display_name        = string
    subscription_status = optional(string, "OPT_IN")
  }))
  description = <<-EOT
    Topics to create for the contact list. At least one topic is required in
    order to use Amazon's SES subscription management features. Only used if
    `create_contact_list` is `true`.
    EOT
  default = {
    general = {
      description         = "General notifications"
      display_name        = "General"
      subscription_status = "OPT_IN"
    }
  }
}

variable "dmarc_rua_mailbox" {
  type        = string
  description = "The mailbox where DMARC RUA reports will be sent."
  default     = "dmarc"
}

variable "domain" {
  type        = string
  description = "The domain to register with SES."
}

variable "environment" {
  type        = string
  description = <<-EOT
    Name of the deployment environment. Used to prefix resource names.
    EOT
  default     = "development"
}

variable "from_subdomain" {
  type        = string
  description = "The subdomain used when sending email from the domain."
  default     = "bounce"
}

variable "hosted_zone_id" {
  type        = string
  description = <<-EOT
    The ID of the hosted zone to use for the SES email address. If not provided,
    the domain will be used to find the hosted zone.
    EOT
  default     = null
}

variable "max_delivery_duration" {
  type        = number
  description = <<-EOT
    The maximum duration, in seconds, that SES will attempt to deliver an email.
    If the email is not delivered within this time, it will be marked as failed.
    You may want to adjust this based on the urgency of the emails you're
    sending.
    EOT
  default     = 3600
}

variable "project" {
  type        = string
  description = <<-EOT
    Project these resources are supporting. Used to prefix resource names.
    EOT
}

variable "require_tls" {
  type        = bool
  description = <<-EOT
    Whether to require TLS for email sent using the configuration set. If
    `true`, emails will be rejected if the receiving mail server does not
    support a compatible TLS version. This _may_ result in recipients who are
    using older mail systems being unable to receive email. When `false`, SES
    will still attempt to use TLS if it's available, but will fallback to an
    unencrypted connection if it's not.
    EOT
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to be applied to all resources."
  default     = {}
}
