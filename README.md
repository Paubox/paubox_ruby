<img src="https://avatars.githubusercontent.com/u/22528478?s=200&v=4" alt="Paubox" width="150px">

# Paubox Gem
This is the official Ruby wrapper for the Paubox Email API. The Paubox Email API allows your application to send secure, HIPAA compliant email via Paubox and track deliveries and opens.

It extends the [Ruby Mail Library](https://github.com/mikel/mail) for seamless integration in your existing Ruby application. The API wrapper also allows you to construct and send messages directly without the Ruby Mail Library.

# Table of Contents
* [Installation](#installation)
*  [Usage](#usage)
*  [Contributing](#contributing)
*  [License](#license)


<a name="#installation"></a>
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paubox'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install paubox

### Getting Paubox API Credentials
You will need to have a Paubox account. You can [sign up here](https://www.paubox.com/join/see-pricing?unit=messages).

Once you have an account, follow the instructions on the Rest API dashboard to verify domain ownership and generate API credentials.

### Configuring API Credentials
Include your API credentials in an initializer (e.g. config/initializers/paubox.rb in Rails).

Keep your API credentials out of version control. Store these in environment variables.

```ruby
Paubox.configure do |config|
  config.api_key = ENV['PAUBOX_API_KEY']
  config.api_user = ENV['PAUBOX_API_USER']
end
```

If you need to send from multiple domains, you can pass credentials in the options hash when you set Ruby Mail's `Mail#delivery_method`, or when using `Paubox::Message`, when you instantiate `Paubox::Client`.

**(optional) Setting credentials when using Ruby Mail:**

```ruby
message = Mail.new do
  ...
  delivery_method(Mail::Paubox, api_key: ENV['PAUBOX_API_KEY'],
                                api_user: ENV['PAUBOX_API_USER'])
end
```

**(optional) Setting credentials when using Paubox::Client:**

```ruby
client = Paubox::Client.new(api_key: ENV['PAUBOX_API_KEY'],
                            api_user: ENV['PAUBOX_API_USER'])
```

<a name="#usage"></a>
## Usage

### Sending Messages with the Ruby Mail Library

Using the Ruby Mail Library? Sending via Paubox is easy. Just build a message as normal and set Mail::Paubox as the delivery method.

```ruby
require 'Paubox'
require 'json'
require 'mail'

message = Mail.new do
  from            'you@yourdomain.com'
  to              'someone@somewhere.com'
  cc              'another@somewhere.com'
  subject         'HIPAA-compliant email made easy'

  text_part do
    body          'This message will be sent securely by Paubox.'
  end

  html_part do
    content_type  'text/html; charset=UTF-8'
    body          '<h1>This message will be sent securely by Paubox.</h1>'
  end

  delivery_method Mail::Paubox
end

message.deliver!
=> {"message"=>"Service OK", "sourceTrackingId"=>"2a3c048485aa4cf6"}

message.source_tracking_id
=> "2a3c048485aa4cf6"
```

### Allowing non-TLS message delivery

If you want to send non-PHI mail that does not need to be HIPAA compliant, you can allow the message delivery to take place even if a TLS connection is unavailable. This means a message will not be converted into a secure portal message when a non-TLS connection is encountered.

```ruby
require 'Paubox'
require 'json'
require 'mail'

message = Mail.new do
  from            'you@yourdomain.com'
  to              'someone@somewhere.com'
  subject         'Sending non-PHI'
  body            'This message delivery will not enforce TLS transmission.'

  delivery_method Mail::Paubox
end

message.allow_non_tls = true
message.deliver!
```

### Forcing Secure Notifications

Paubox Secure Notifications allow an extra layer of security, especially when coupled with an organization's requirement for message recipients to use 2-factor authentication to read messages (this setting is available to org administrators in the Paubox Admin Panel).

Instead of receiving an email with the message contents, the recipient will receive a notification email that they have a new message in Paubox.

```ruby
require 'Paubox'
require 'json'
require 'mail'

message = Mail.new do
  from            'you@yourdomain.com'
  to              'someone@somewhere.com'
  subject         'Sending non-PHI'
  body            'This message delivery will not enforce TLS transmission.'

  delivery_method Mail::Paubox
end

message.force_secure_notification = 'true'
message.deliver!
```

### Adding Attachments

```ruby
require 'Paubox'
require 'json'
require 'mail'

message = Mail.new do
  from            'you@yourdomain.com'
  to              'someone@somewhere.com'
  cc              'another@somewhere.com'
  subject         'HIPAA-compliant email made easy'

  delivery_method Mail::Paubox
end

message.add_file("path_to_your_file")
message.deliver!
```

### Sending Messages using just the Paubox API
You don't need to use Ruby Mail to build and send messages with Paubox.

```ruby
require 'Paubox'
require 'json'

args = { from: 'you@yourdomain.com',
         to: 'someone@domain.com, someone-else@domain.com',
         cc: ['another@domain.com', 'yet-another@domain.com'],
         bcc: 'bcc-recipient@domain.com',
         reply_to: 'reply-to@yourdomain.com',
         subject: 'Testing!',
         text_content: 'Hello World!',
         html_content: '<h1>Hello World!</h1>'         
      }

message = Paubox::Message.new(args)

client = Paubox::Client.new
client.deliver_mail(message)
=> {"message"=>"Service OK", "sourceTrackingId"=>"2a3c048485aa4cf6"}
```
### Manage Dynamic Templates
Can manage(create, update, find and delete) the dynamic templates. by using the following commands and use these to send the Templated Messages.

```ruby
require 'Paubox'
require 'json'

template_name = "Template name"
template_path = "Template File path"

# For create the new dynamic template
Paubox::DynamicTemplates.create(template_name, template_path)
=> { "RestClient::Response"=>"201", "message"=>"Template #{name} created!" }

# For getting the list of all dynamic template of your organization
Paubox::DynamicTemplates.list
=>[{"id"=>1, "name"=>"test", "api_customer_id"=>11},
 {"id"=>3, "name"=>"Test", "api_customer_id"=>11}]


# For update the existing dynamic template
dynamic_template = Paubox::DynamicTemplates.find(template_id)
dynamic_template.update(template_path, template_name)
=> {"RestClient::Response"=>"200", "message"=>"Template #{name} updated!"}

# For delete the existing dynamic template
dynamic_template = Paubox::DynamicTemplates.find(template_id)
dynamic_template.delete
=> {"RestClient::Response"=>"200", "message"=>"Template #{name} deleted!"}


```

### Send Messages using Dynamic Templates
Using above[dynamic templates](https://docs.paubox.com/docs/paubox_email_api/dynamic_templates/) is similar to sending a regular message. Just create a `Paubox::TemplatedMessage` object and pass a `template` object with the name of the template and variables:

```ruby
require 'Paubox'
require 'json'

args = { from: 'you@yourdomain.com',
         to: 'someone@domain.com, someone-else@domain.com',
         cc: ['another@domain.com', 'yet-another@domain.com'],
         bcc: 'bcc-recipient@domain.com',
         reply_to: 'reply-to@yourdomain.com',
         subject: 'Testing!',
         template: {
          name: 'Test Template',
          values: {
            first_name: 'Timothy',
            last_name: 'Testerson'
          }
        }			
      }

templated_message = Paubox::TemplatedMessage.new(args)

client = Paubox::Client.new
client.deliver_mail(templated_message)
=> {"sourceTrackingId"=>"166904b5-dce7-4de1-92e8-3d505c165ff5", "data"=>"Service OK"}
```

_Note that there is no `content` when using templated messages._


### Checking Email Dispositions
```ruby
require 'Paubox'
require 'json'

client = Paubox::Client.new
email_disposition = client.email_disposition('2a3c048485aa4cf6')

# Get array of email_dispositions. One email_disposition is generated for each recipient.
message_deliveries = email_disposition.message_deliveries
=> [<struct Paubox::EmailDisposition::MessageDelivery recipient="test@domain.com", status=#<struct Paubox::EmailDisposition::MessageDeliveryStatus delivery_status="delivered", delivery_time=Mon, 30 Apr 2018 12:54:19 -0700, opened_status="opened", opened_time=Mon, 30 Apr 2018 12:55:19 -0700>>]

# Inspect a message delivery
delivery = message_deliveries.first

delivery.recipient
=> "test@domain.com"

# Inspect the message delivery status
status = delivery.status

status.delivery_status
=> "delivered"

status.delivery_time
=> Mon, 30 Apr 2018 12:54:19 -0700

# opened_status is only available for single-recipient messages
status.opened_status
=> "opened"

# opened_time is only available for single-recipient messages
status.opened_time
=> Mon, 30 Apr 2018 12:55:19 -0700
```

<a name="#contributing"></a>
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paubox/paubox_ruby.


<a name="#license"></a>
## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Copyright
Copyright &copy; 2022, Paubox, Inc.

