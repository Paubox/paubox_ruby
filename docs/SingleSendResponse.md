# Paubox::SingleSendResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **source_tracking_id** | **String** | Identifier for tracking the message source. | [optional] |
| **custom_headers** | **Hash&lt;String, String&gt;** |  | [optional] |
| **data** | **String** |  | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::SingleSendResponse.new(
  source_tracking_id: null,
  custom_headers: null,
  data: Service OK
)
```

