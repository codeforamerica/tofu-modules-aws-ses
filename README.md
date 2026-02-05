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

| Name               | Description                                                                                                                                                                                        | Type           | Default         | Required |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | --------------- | -------- |
| domain             | The domain to register with SES.                                                                                                                                                                   | `string`       | n/a             | yes      |
| project            | Project these resources are supporting. Used to prefix resource names.                                                                                                                             | `string`       | n/a             | yes      |
| allowed_recipients | List of email addresses to create identities for, allowing them to receive email from the domain. This is required in order for recipients to receive email from the domain while in sandbox mode. | `list(string)` | `[]`            | no       |
| dmarc_rua_mailbox  | The mailbox where DMARC RUA reports will be sent.                                                                                                                                                  | `string`       | `"dmarc"`       | no       |
| environment        | Name of the deployment environment. Used to prefix resource names.                                                                                                                                 | `string`       | `"development"` | no       |
| from_subdomain     | The subdomain used when sending email from the domain.                                                                                                                                             | `string`       | `"bounce"`      | no       |
| tags               | Optional tags to be applied to all resources.                                                                                                                                                      | `list`         | `[]`            | no       |

## Outputs

| Name                 | Description                                                                                                                                                                                   | Type          |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| iam_policy_arn       | ARN of the IAM policy that allows sending email via SES using the identity created by this module. Attach to an IAM role via `aws_iam_role_policy_attachment` to allow sending email via SES. | `string`      |
| identity_arn         | ARN of the created SES domain identity.                                                                                                                                                       | `string`      |
| recipient_identities | ARNs of the SES email identities created for allowed recipients.                                                                                                                              | `map(string)` |

## Contributing

Follow the [contributing guidelines][contributing] to contribute to this
repository.

[aws_fargate_service]: https://github.com/codeforamerica/tofu-modules-aws-fargate-service
[badge-release]: https://img.shields.io/github/v/release/codeforamerica/tofu-modules-aws-ses?logo=github&label=Latest%20Release
[contributing]: CONTRIBUTING.md
[latest-release]: https://github.com/codeforamerica/tofu-modules-aws-ses/releases/latest
[prod-access]: https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html
[ses]: https://docs.aws.amazon.com/ses/latest/dg/Welcome.html
