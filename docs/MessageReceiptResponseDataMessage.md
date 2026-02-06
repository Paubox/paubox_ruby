# Paubox::MessageReceiptResponseDataMessage

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | The message ID |  |
| **message_deliveries** | [**Array&lt;MessageDelivery&gt;**](MessageDelivery.md) |  |  |
| **total_opens** | **Integer** | Total number of opens (single recipient only) | [optional] |
| **distinct_opens** | **Integer** | Number of distinct opens (single recipient only) | [optional] |
| **total_click_count** | **Integer** | Total number of clicks (single recipient only) | [optional] |
| **clicks_per_link** | [**Array&lt;ClickData&gt;**](ClickData.md) | Click tracking data per link (single recipient only) | [optional] |
| **unsubscribed** | **Boolean** | Whether the recipient has unsubscribed (single recipient only) | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::MessageReceiptResponseDataMessage.new(
  id: &lt;f4a9b518-439c-497d-b87f-dfc9cc19194b@authorized_domain.com&gt;,
  message_deliveries: null,
  total_opens: 1,
  distinct_opens: 1,
  total_click_count: 2,
  clicks_per_link: null,
  unsubscribed: false
)
```

