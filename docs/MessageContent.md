# Paubox::MessageContent

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **text_plain** | **String** | Plain text message body. Required if text/html is not provided. | [optional] |
| **text_html** | **String** | HTML message body. May be HTML-escaped, base64-encoded, or a valid unescaped string. CSS in &lt;style&gt; tags will be rendered inline.  | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageContent.new(
  text_plain: null,
  text_html: null
)
```

