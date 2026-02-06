# Paubox::MessageReceiptErrorResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **errors** | [**Array&lt;ErrorResponseErrorsInner&gt;**](ErrorResponseErrorsInner.md) |  |  |
| **source_tracking_id** | **String** | The tracking ID for the message |  |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageReceiptErrorResponse.new(
  errors: null,
  source_tracking_id: 6e1cf9a4-7bde-4834-8d200-ed424b50c8a7
)
```

