# AWS Simple Email Service (SES) Modules

[![GitHub Release][badge-release]][latest-release]

This modules configures configures a domain for Amazon [Simple Email
Service][ses], optional email identities to support receiving mail from
a sandbox account, and an IAM policy that allows sending mail using the created
identities.

## Usage

Add this module to your `main.tf` (or appropriate) file and configure the inputs
to match your desired configuration. For example:

> [!TIP]
> All new SES accounts are placed in sandbox mode, with several restrictions on
> sending email. While in sandbox mode, you can only send email to other
> verified identities.
>
> The easiest way to do this, is to use the `allowed_recipients` input to
> specify a list of recipeints that should be authorized to recieve email from
> the domain. A verification email will be sent to each address. The address
> _must_ be verified before it can receive mail.
>
> Once your acccount has been approved for [production access][prod-access], you
> no longer need this.

```hcl
module "ses" {
  source = "github.com/codeforamerica/tofu-modules-aws-ses?ref=1.0.0"

  project            = "my-project"
  environment        = "production"
  domain             = "my-project.com"
  allowed_recipients = ["me@example.com"]
}
```

You can attach the create IAM policy to one or more IAM roles attached to
resources, to allow those resources to send mail using the created identities.

> [!NOTE]
> You can also pass the policy ARN to another module that's responsible for
> configuring your roles, such as our [aws_fargate_service] module.

For example:

```hcl
resource "aws_iam_role_policy_attachment" "web_ses" {
  role       = aws_iam_role.web.name
  policy_arn = module.ses.iam_policy_arn
}
```

Make sure you re-run `tofu init` after adding the module to your configuration.

```bash
tofu init
tofu plan
```

## Inputs

| Name                  | Description                                                                                                                                                                                                                                                                                                                                                                                                                  | Type           | Default           | Required |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ----------------- | -------- |
| domain                | The domain to register with SES.                                                                                                                                                                                                                                                                                                                                                                                             | `string`       | n/a               | yes      |
| project               | Project these resources are supporting. Used to prefix resource names.                                                                                                                                                                                                                                                                                                                                                       | `string`       | n/a               | yes      |
| allowed_recipients    | List of email addresses to create identities for, allowing them to receive email from the domain. This is required in order for recipients to receive email from the domain while in sandbox mode.                                                                                                                                                                                                                           | `list(string)` | `[]`              | no       |
| create_contact_list   | Whether to create a contact list to manage subscriptions for the domain.                                                                                                                                                                                                                                                                                                                                                     | `bool`         | `true`            | no       |
| contact_list_topics   | Topics to create for the contact list. At least one topic is required in order to use Amazon's SES [subscription management][sub-management] features. Only used if `create_contact_list` is `true`.                                                                                                                                                                                                                         | `map(object)`  | `{general = {…}}` | no       |
| dmarc_rua_mailbox     | The mailbox where DMARC RUA reports will be sent.                                                                                                                                                                                                                                                                                                                                                                            | `string`       | `"dmarc"`         | no       |
| environment           | Name of the deployment environment. Used to prefix resource names.                                                                                                                                                                                                                                                                                                                                                           | `string`       | `"development"`   | no       |
| from_subdomain        | The subdomain used when sending email from the domain.                                                                                                                                                                                                                                                                                                                                                                       | `string`       | `"bounce"`        | no       |
| max_delivery_duration | The maximum duration, in seconds, that SES will attempt to deliver an email. If the email is not delivered within this time, it will be marked as failed. You may want to adjust this based on the urgency of the emails you're sending.                                                                                                                                                                                     | `number`       | `3600`            | no       |
| require_tls           | Whether to require TLS for email sent using the configuration set. If `true`, emails will be rejected if the receiving mail server does not support a compatible TLS version. This _may_ result in recipients who are using older mail systems being unable to receive email. When `false`, SES will still [attempt to use TLS][optional-tls] if it's available, but will fallback to an unencrypted connection if it's not. | `bool`         | `false`           | no       |
| tags                  | Optional tags to be applied to all resources.                                                                                                                                                                                                                                                                                                                                                                                | `map(string)`  | `{}`              | no       |

## Outputs

| Name                   | Description                                                                                                                                                                                   | Type           |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| configuration_set_name | Name of the created SES configuration set.                                                                                                                                                    | `string`       |
| contact_list_name      | Name of the created SES contact list, if created.                                                                                                                                             | `string`       |
| contact_list_topics    | Topics created for the contact list, if created.                                                                                                                                              | `list(string)` |
| iam_policy_arn         | ARN of the IAM policy that allows sending email via SES using the identity created by this module. Attach to an IAM role via `aws_iam_role_policy_attachment` to allow sending email via SES. | `string`       |
| identity_arn           | ARN of the created SES domain identity.                                                                                                                                                       | `string`       |
| recipient_identities   | ARNs of the SES email identities created for allowed recipients.                                                                                                                              | `map(string)`  |

## Contributing

Follow the [contributing guidelines][contributing] to contribute to this
repository.

[aws_fargate_service]: https://github.com/codeforamerica/tofu-modules-aws-fargate-service
[badge-release]: https://img.shields.io/github/v/release/codeforamerica/tofu-modules-aws-ses?logo=github&label=Latest%20Release
[contributing]: CONTRIBUTING.md
[latest-release]: https://github.com/codeforamerica/tofu-modules-aws-ses/releases/latest
[optional-tls]: https://docs.aws.amazon.com/ses/latest/dg/security-protocols.html#security-ses-to-receiver
[prod-access]: https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html
[ses]: https://docs.aws.amazon.com/ses/latest/dg/Welcome.html
[sub-management]: https://docs.aws.amazon.com/ses/latest/dg/sending-email-subscription-management.html
