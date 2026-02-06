# Paubox::Message

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **recipients** | **Array&lt;String&gt;** |  |  |
| **bcc** | **Array&lt;String&gt;** |  | [optional] |
| **cc** | **Array&lt;String&gt;** |  | [optional] |
| **headers** | [**MessageHeaders**](MessageHeaders.md) |  |  |
| **allow_non_tls** | **Boolean** | Allow delivery over non-TLS rather than converting to a Secure Portal message. Not HIPAA-compliant if the message contains PHI.  | [optional][default to false] |
| **force_secure_notification** | **Boolean** | Force delivery as a Paubox Secure Message; recipient gets a pickup notification with a link.  | [optional][default to false] |
| **content** | [**MessageContent**](MessageContent.md) |  |  |
| **attachments** | [**Array&lt;Attachment&gt;**](Attachment.md) |  | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::Message.new(
  recipients: null,
  bcc: null,
  cc: null,
  headers: null,
  allow_non_tls: null,
  force_secure_notification: null,
  content: null,
  attachments: null
)
```

