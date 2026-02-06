# Paubox::MessageDelivery

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **recipient** | **String** | The recipient email address |  |
| **status** | [**DeliveryStatus**](DeliveryStatus.md) |  |  |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageDelivery.new(
  recipient: recipient@host.com,
  status: null
)
```

