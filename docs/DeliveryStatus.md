# Paubox::DeliveryStatus

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **delivery_status** | **String** | The delivery status of the message |  |
| **delivery_time** | **String** | The time when the message was delivered (if applicable) | [optional] |
| **opened_status** | **String** | Whether the message was opened (single recipient only) | [optional] |
| **opened_time** | **String** | The time when the message was first opened (single recipient only) | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::DeliveryStatus.new(
  delivery_status: delivered,
  delivery_time: Mon, 23 Apr 2018 13:27:34 -0700,
  opened_status: opened,
  opened_time: Mon, 23 Apr 2018 13:27:51 -0700
)
```

