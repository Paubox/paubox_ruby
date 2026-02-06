# Paubox::SingleSendRequestData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **message** | [**Message**](Message.md) |  |  |
| **override_open_tracking** | **Boolean** | Set to true to enable open tracking for this message. | [optional] |
| **override_link_tracking** | **Boolean** | Set to true to enable click tracking for this message (up to 1000 links). | [optional] |
| **unsubscribe_url** | **String** | URL to redirect unsubscribe requests for unsubscribe tracking. | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::SingleSendRequestData.new(
  message: null,
  override_open_tracking: null,
  override_link_tracking: null,
  unsubscribe_url: null
)
```

