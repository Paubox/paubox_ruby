# Paubox::DynamicTemplatesApi

All URIs are relative to *https://api.paubox.net/v1/YOUR_API_USERNAME*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**create_dynamic_template**](DynamicTemplatesApi.md#create_dynamic_template) | **POST** /dynamic_templates | Create a dynamic template |
| [**delete_dynamic_template**](DynamicTemplatesApi.md#delete_dynamic_template) | **DELETE** /dynamic_templates/{id} | Delete a dynamic template |
| [**get_dynamic_template**](DynamicTemplatesApi.md#get_dynamic_template) | **GET** /dynamic_templates/{id} | Get a dynamic template |
| [**list_dynamic_templates**](DynamicTemplatesApi.md#list_dynamic_templates) | **GET** /dynamic_templates | List all dynamic templates |
| [**send_templated_message**](DynamicTemplatesApi.md#send_templated_message) | **POST** /templated_messages | Send a dynamically templated message |
| [**update_dynamic_template**](DynamicTemplatesApi.md#update_dynamic_template) | **PATCH** /dynamic_templates/{id} | Update a dynamic template |


## create_dynamic_template

> <DynamicTemplateResponse> create_dynamic_template(data_name, data_body)

Create a dynamic template

Upload a new Handlebars template for dynamic content generation

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new
data_name = 'data_name_example' # String | Name for the template
data_body = File.new('/path/to/some/file') # File | Handlebars template file (.hbs)

begin
  # Create a dynamic template
  result = api_instance.create_dynamic_template(data_name, data_body)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->create_dynamic_template: #{e}"
end
```

#### Using the create_dynamic_template_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DynamicTemplateResponse>, Integer, Hash)> create_dynamic_template_with_http_info(data_name, data_body)

```ruby
begin
  # Create a dynamic template
  data, status_code, headers = api_instance.create_dynamic_template_with_http_info(data_name, data_body)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DynamicTemplateResponse>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->create_dynamic_template_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **data_name** | **String** | Name for the template |  |
| **data_body** | **File** | Handlebars template file (.hbs) |  |

### Return type

[**DynamicTemplateResponse**](DynamicTemplateResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: multipart/form-data
- **Accept**: application/json


## delete_dynamic_template

> <DeleteDynamicTemplate200Response> delete_dynamic_template(id)

Delete a dynamic template

Delete a specific dynamic template by ID

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new
id = 'id_example' # String | Template ID to delete

begin
  # Delete a dynamic template
  result = api_instance.delete_dynamic_template(id)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->delete_dynamic_template: #{e}"
end
```

#### Using the delete_dynamic_template_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DeleteDynamicTemplate200Response>, Integer, Hash)> delete_dynamic_template_with_http_info(id)

```ruby
begin
  # Delete a dynamic template
  data, status_code, headers = api_instance.delete_dynamic_template_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DeleteDynamicTemplate200Response>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->delete_dynamic_template_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Template ID to delete |  |

### Return type

[**DeleteDynamicTemplate200Response**](DeleteDynamicTemplate200Response.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## get_dynamic_template

> <DynamicTemplateResponse> get_dynamic_template(id)

Get a dynamic template

Retrieve a specific dynamic template by ID

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new
id = 'id_example' # String | Template ID

begin
  # Get a dynamic template
  result = api_instance.get_dynamic_template(id)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->get_dynamic_template: #{e}"
end
```

#### Using the get_dynamic_template_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DynamicTemplateResponse>, Integer, Hash)> get_dynamic_template_with_http_info(id)

```ruby
begin
  # Get a dynamic template
  data, status_code, headers = api_instance.get_dynamic_template_with_http_info(id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DynamicTemplateResponse>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->get_dynamic_template_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Template ID |  |

### Return type

[**DynamicTemplateResponse**](DynamicTemplateResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## list_dynamic_templates

> <DynamicTemplateListResponse> list_dynamic_templates

List all dynamic templates

Retrieve all dynamic templates for your organization

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new

begin
  # List all dynamic templates
  result = api_instance.list_dynamic_templates
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->list_dynamic_templates: #{e}"
end
```

#### Using the list_dynamic_templates_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DynamicTemplateListResponse>, Integer, Hash)> list_dynamic_templates_with_http_info

```ruby
begin
  # List all dynamic templates
  data, status_code, headers = api_instance.list_dynamic_templates_with_http_info
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DynamicTemplateListResponse>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->list_dynamic_templates_with_http_info: #{e}"
end
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**DynamicTemplateListResponse**](DynamicTemplateListResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## send_templated_message

> <SingleSendResponse> send_templated_message(templated_message_request)

Send a dynamically templated message

Send an email using a dynamic template with variable substitution

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new
templated_message_request = Paubox::TemplatedMessageRequest.new({data: Paubox::TemplatedMessageRequestData.new({template_name: 'detailed_test', template_values: '{ "name": "Howard", "conditional":"true","items":["one","two","three"] }', message: Paubox::TemplatedMessage.new({recipients: ['recipients_example'], headers: Paubox::TemplatedMessageHeaders.new({subject: 'subject_example', from: 'from_example'})})})}) # TemplatedMessageRequest | 

begin
  # Send a dynamically templated message
  result = api_instance.send_templated_message(templated_message_request)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->send_templated_message: #{e}"
end
```

#### Using the send_templated_message_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SingleSendResponse>, Integer, Hash)> send_templated_message_with_http_info(templated_message_request)

```ruby
begin
  # Send a dynamically templated message
  data, status_code, headers = api_instance.send_templated_message_with_http_info(templated_message_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SingleSendResponse>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->send_templated_message_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **templated_message_request** | [**TemplatedMessageRequest**](TemplatedMessageRequest.md) |  |  |

### Return type

[**SingleSendResponse**](SingleSendResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## update_dynamic_template

> <DynamicTemplateResponse> update_dynamic_template(id, opts)

Update a dynamic template

Update an existing Handlebars template

### Examples

```ruby
require 'time'
require 'paubox'
# setup authorization
Paubox.configure do |config|
  # Configure API key authorization: PauboxToken
  config.api_key['Authorization'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  # config.api_key_prefix['Authorization'] = 'Bearer'
end

api_instance = Paubox::DynamicTemplatesApi.new
id = 'id_example' # String | Template ID to update
opts = {
  data_name: 'data_name_example', # String | Updated name for the template
  data_body: File.new('/path/to/some/file') # File | Updated Handlebars template file (.hbs)
}

begin
  # Update a dynamic template
  result = api_instance.update_dynamic_template(id, opts)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->update_dynamic_template: #{e}"
end
```

#### Using the update_dynamic_template_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<DynamicTemplateResponse>, Integer, Hash)> update_dynamic_template_with_http_info(id, opts)

```ruby
begin
  # Update a dynamic template
  data, status_code, headers = api_instance.update_dynamic_template_with_http_info(id, opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <DynamicTemplateResponse>
rescue Paubox::ApiError => e
  puts "Error when calling DynamicTemplatesApi->update_dynamic_template_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **id** | **String** | Template ID to update |  |
| **data_name** | **String** | Updated name for the template | [optional] |
| **data_body** | **File** | Updated Handlebars template file (.hbs) | [optional] |

### Return type

[**DynamicTemplateResponse**](DynamicTemplateResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: multipart/form-data
- **Accept**: application/json

