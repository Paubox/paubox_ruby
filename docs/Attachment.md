# Paubox::Attachment

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **file_name** | **String** |  |  |
| **content_type** | **String** | Valid MIME type, e.g., application/pdf. |  |
| **content** | **String** | Base64-encoded file contents. |  |

## Example

```ruby
require 'paubox'

instance = Paubox::Attachment.new(
  file_name: null,
  content_type: null,
  content: null
)
```

