# frozen_string_literal: true

module Helpers
  module MailHelper
    require 'base64'
    require 'mail'
    require 'tempfile'
    require 'Paubox'
    require 'json'


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

    message.allow_non_tls = true
    message.force_secure_notification = 'true'
    

    file = Tempfile.new(['test', '.csv'])
    file.write('first, second')
    file.close
    message.add_file(file.path)

    message.deliver!
    


    def mail_defaults
      { 'from' => 'me@test.paubox.net',
        'to' => 'you@test.paubox.net',
        'cc' => 'cc@test.paubox.net',
        'reply_to' => 'reply-to@test.paubox.net',
        'subject' => 'Test subject' }
    end

    def base_message(args = {})
      args = mail_defaults.merge(args)
      mail = Mail.new do
        delivery_method Mail::Paubox
      end
      args.each { |k, v| mail[k] = v }
      mail
    end

    def plain_text_message(args = {})
      base_message({ 'body' => 'Test plain text body.' }.merge(args))
    end

    def html_only_message(args = {})
      mail = base_message(args)
      html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body '<h1>Test HTML</h1>'
      end
      mail.html_part = html_part
      mail
    end

    def multipart_message(args = {})
      mail = base_message(args)
      text_part = Mail::Part.new do
        body 'Text plain text body.'
      end
      html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body '<h1>Test HTML</h1>'
      end
      mail.text_part = text_part
      mail.html_part = html_part
      mail
    end

    def message_with_attachments(args = {})
      mail = multipart_message(args)
      file = Tempfile.new(['test', '.csv'])
      file.write('first, second')
      file.close
      mail.add_file(file.path)
      mail
    end

    def base64_encode_if_needed(str)
      return str if base64_encoded?(str.to_s)

      Base64.encode64(str.to_s)
    end
  end
end
