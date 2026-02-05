variable "allowed_recipients" {
  type        = list(string)
  description = <<-EOT
    List of email addresses to create identities for, allowing them to receive
    email from the domain. This is required in order for recipients to receive
    email from the domain while in sandbox mode.
    EOT
  default     = []
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

variable "project" {
  type        = string
  description = <<-EOT
    Project these resources are supporting. Used to prefix resource names.
    EOT
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to be applied to all resources."
  default     = {}
}
