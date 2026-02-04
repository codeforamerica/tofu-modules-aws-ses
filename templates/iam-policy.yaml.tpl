Version: "2012-10-17"
Statement:
  - Effect: Allow
    Action:
      - ses:SendEmail
      - ses:SendRawEmail
    Resource:
      %{ for identity in identities ~}
      - "${identity}"
      %{ endfor }

