# Paubox::TemplatedMessageHeaders

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **subject** | **String** | Message subject (can include template variables) |  |
| **from** | **String** | Must match the verified domain of your API key. |  |
| **reply_to** | **String** | Reply-to address; must match a verified domain if different from from. | [optional] |
| **list_unsubscribe** | **String** | Insert a List-Unsubscribe header (mailto and/or http). See RFC guidance for syntax.  | [optional] |
| **list_unsubscribe_post** | **String** | Used in conjunction with List-Unsubscribe header. | [optional] |
| **additional_properties** | **String** | Any additional custom header values. | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::TemplatedMessageHeaders.new(
  subject: null,
  from: null,
  reply_to: null,
  list_unsubscribe: null,
  list_unsubscribe_post: null,
  additional_properties: null
)
```

