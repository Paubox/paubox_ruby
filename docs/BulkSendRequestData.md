# Paubox::BulkSendRequestData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **messages** | [**Array&lt;Message&gt;**](Message.md) | Recommended 50 or fewer per request. |  |

## Example

```ruby
require 'paubox'

instance = Paubox::BulkSendRequestData.new(
  messages: null
)
```

