# Paubox::MessageReceiptResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **source_tracking_id** | **String** | The tracking ID for the message |  |
| **data** | [**MessageReceiptResponseData**](MessageReceiptResponseData.md) |  |  |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageReceiptResponse.new(
  source_tracking_id: 6e1cf9a4-7bde-4834-8200-ed424b50c8a7,
  data: null
)
```

