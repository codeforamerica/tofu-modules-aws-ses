variable "dmarc_rua_mailbox" {
  type        = string
  description = "The mailbox where DMARC RUA reports will be sent."
  default     = "dmarc"
}

variable "domain" {
  type        = string
  description = "The domain to use for the SES email address."
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. prod, staging), used in the SES send IAM policy name."
  default     = "development"
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
  description = "Project name, used in the SES send IAM policy name (format: project-environment-ses-send)."
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to be applied to all resources."
  default     = {}
}
