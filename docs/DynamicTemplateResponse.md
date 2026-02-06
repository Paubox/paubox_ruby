# Paubox::DynamicTemplateResponse

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Template ID | [optional] |
| **name** | **String** | Template name | [optional] |
| **body** | **String** | Template content (Handlebars) | [optional] |
| **created_at** | **Time** | Template creation timestamp | [optional] |
| **updated_at** | **Time** | Template last update timestamp | [optional] |

## Example

```ruby
require 'paubox'

instance = Paubox::DynamicTemplateResponse.new(
  id: template_123,
  name: welcome_template,
  body: Hello {{name}}, welcome to our service!,
  created_at: null,
  updated_at: null
)
```

