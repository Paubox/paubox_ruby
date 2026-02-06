# Paubox::ClickData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **click_count** | **Integer** | Number of clicks on this specific link |  |
| **target_url** | **String** | The URL that was clicked |  |

## Example

```ruby
require 'paubox'

instance = Paubox::ClickData.new(
  click_count: 1,
  target_url: amazon.com
)
```

