# Paubox::TemplatedMessageRequestData

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **template_name** | **String** | The name of the template to use (must match exactly) |  |
| **template_values** | **String** | JSON-formatted string containing template variable values |  |
| **message** | [**TemplatedMessage**](TemplatedMessage.md) |  |  |

## Example

```ruby
require 'paubox'

instance = Paubox::TemplatedMessageRequestData.new(
  template_name: detailed_test,
  template_values: { &quot;name&quot;: &quot;Howard&quot;, &quot;conditional&quot;:&quot;true&quot;,&quot;items&quot;:[&quot;one&quot;,&quot;two&quot;,&quot;three&quot;] },
  message: null
)
```

