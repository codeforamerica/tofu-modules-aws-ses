variable "domain" {
  type        = string
  description = "The domain to use for the SES email address."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]\\.[a-zA-Z]{2,}$", var.domain))
    error_message = "The domain must be a valid domain name."
  }
}

variable "hosted_zone_id" {
  type        = string
  description = <<-EOT
    The ID of the hosted zone to use for the SES email address. If not provided,
    the domain will be used to find the hosted zone.
    EOT
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to be applied to all resources."
  default     = {}
}
