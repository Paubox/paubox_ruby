# Paubox::MessagesApi

All URIs are relative to *https://api.paubox.net/v1/YOUR_API_USERNAME*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**get_message_receipt**](MessagesApi.md#get_message_receipt) | **GET** /message_receipt | Get email disposition |
| [**send_bulk_messages**](MessagesApi.md#send_bulk_messages) | **POST** /bulk_messages | Send multiple email messages (batch) |
| [**send_message**](MessagesApi.md#send_message) | **POST** /messages | Send a single email message |


## get_message_receipt

> <MessageReceiptResponse> get_message_receipt(source_tracking_id)

Get email disposition

Retrieve delivery status, open tracking, and click tracking information for a sent message

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

api_instance = Paubox::MessagesApi.new
source_tracking_id = '6e1cf9a4-7bde-4834-8200-ed424b50c8a7' # String | The tracking ID returned when the message was sent

begin
  # Get email disposition
  result = api_instance.get_message_receipt(source_tracking_id)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->get_message_receipt: #{e}"
end
```

#### Using the get_message_receipt_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<MessageReceiptResponse>, Integer, Hash)> get_message_receipt_with_http_info(source_tracking_id)

```ruby
begin
  # Get email disposition
  data, status_code, headers = api_instance.get_message_receipt_with_http_info(source_tracking_id)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <MessageReceiptResponse>
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->get_message_receipt_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **source_tracking_id** | **String** | The tracking ID returned when the message was sent |  |

### Return type

[**MessageReceiptResponse**](MessageReceiptResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## send_bulk_messages

> <BulkSendResponse> send_bulk_messages(bulk_send_request)

Send multiple email messages (batch)

Sends multiple messages in one request. Paubox recommends batches of 50 or fewer. Source tracking IDs are returned in the same order as the messages array. 

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

api_instance = Paubox::MessagesApi.new
bulk_send_request = Paubox::BulkSendRequest.new({data: Paubox::BulkSendRequestData.new({messages: [Paubox::Message.new({recipients: ['recipients_example'], headers: Paubox::MessageHeaders.new({subject: 'subject_example', from: 'from_example'}), content: Paubox::MessageContent.new})]})}) # BulkSendRequest | 

begin
  # Send multiple email messages (batch)
  result = api_instance.send_bulk_messages(bulk_send_request)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->send_bulk_messages: #{e}"
end
```

#### Using the send_bulk_messages_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<BulkSendResponse>, Integer, Hash)> send_bulk_messages_with_http_info(bulk_send_request)

```ruby
begin
  # Send multiple email messages (batch)
  data, status_code, headers = api_instance.send_bulk_messages_with_http_info(bulk_send_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <BulkSendResponse>
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->send_bulk_messages_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **bulk_send_request** | [**BulkSendRequest**](BulkSendRequest.md) |  |  |

### Return type

[**BulkSendResponse**](BulkSendResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## send_message

> <SingleSendResponse> send_message(single_send_request)

Send a single email message

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

api_instance = Paubox::MessagesApi.new
single_send_request = Paubox::SingleSendRequest.new({data: Paubox::SingleSendRequestData.new({message: Paubox::Message.new({recipients: ['recipients_example'], headers: Paubox::MessageHeaders.new({subject: 'subject_example', from: 'from_example'}), content: Paubox::MessageContent.new})})}) # SingleSendRequest | 

begin
  # Send a single email message
  result = api_instance.send_message(single_send_request)
  p result
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->send_message: #{e}"
end
```

#### Using the send_message_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<SingleSendResponse>, Integer, Hash)> send_message_with_http_info(single_send_request)

```ruby
begin
  # Send a single email message
  data, status_code, headers = api_instance.send_message_with_http_info(single_send_request)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <SingleSendResponse>
rescue Paubox::ApiError => e
  puts "Error when calling MessagesApi->send_message_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **single_send_request** | [**SingleSendRequest**](SingleSendRequest.md) |  |  |

### Return type

[**SingleSendResponse**](SingleSendResponse.md)

### Authorization

[PauboxToken](../README.md#PauboxToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

