# Paubox::MessageHeaders

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **subject** | **String** |  |  |
| **from** | **String** | Must match the verified domain of your API key. |  |
| **reply_to** | **String** | Reply-to address; must match a verified domain if different from from. | [optional] |
| **list_unsubscribe** | **String** | Insert a List-Unsubscribe header (mailto and/or http). See RFC guidance for syntax.  | [optional] |
| **list_unsubscribe_post** | **String** | Used in conjunction with List-Unsubscribe header. | [optional] |
| **x_custom_header** | **String** | Example custom header; any custom header may be added with an X- prefix. | [optional] |
| **additional_properties** | **String** | Any additional X- prefixed custom header values. | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageHeaders.new(
  subject: null,
  from: null,
  reply_to: null,
  list_unsubscribe: null,
  list_unsubscribe_post: null,
  x_custom_header: null,
  additional_properties: null
)
```

