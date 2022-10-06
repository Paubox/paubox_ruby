# frozen_string_literal: true

module Helpers
  module MessageHelper
    require 'base64'
    BASE64_REGEX = Regexp.new(%r{^(?:[A-Za-z0-9+/]{4}\n?)*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$})

    def message_defaults
      { from: 'me@test.paubox.com',
        to: 'you@test.paubox.com, someone_else@test.paubox.com',
        cc: ['first@test.paubox.com', 'second@paubox.com'],
        bcc: 'bcc-recipient@test.paubox.com',
        reply_to: 'reply-to@test.paubox.com',
        subject: 'Test subject' }
    end

    def base_message_args(args = {})
      message_defaults.merge(args)
    end

    def plain_text_message_args(args = {})
      base_message_args({ 'body' => 'Test plain text body.' }.merge(args))
    end

    def multipart_message_args(args = {})
      base_message_args({ text_content: 'Plain text body.', html_content: '<h1>Test HTML</h1>' }.merge(args))
    end

    def multipart_message_encoded_args(args = {})
      base_message_args({ text_content: 'Plain text body.', html_content: base64_encode_if_needed('<h1>Test HTML</h1>') }.merge(args))
    end

    def message_with_attachment_args(args = {})
      multipart_message_args({ attachments: [filename: 'test.csv', content_type: 'text/csv',
                                             content: 'first, second '] }.merge(args))
    end

    def message_with_attachment_encoded_args(args = {})
      multipart_message_encoded_args({ attachments: [filename: 'test.csv', content_type: 'text/csv',
                                                     content: 'first, second '] }.merge(args))
    end

    def message_with_force_secure_notification_args(args = {})
      base_message_args({ force_secure_notification: 'true' }.merge(args))
    end

    def message_with_invalid_force_secure_notification_args(args = {})
      base_message_args({ force_secure_notification: true }.merge(args))
    end

    def message_with_template_args(args = {})
      base_message_args({ template: { name: 'Test Template', values: { first_name: 'Timothy', last_name: 'Testerson' } }}).merge(args)
    end

    def base64_encoded?(value)
      return false unless value.is_a?(String)

      !value.strip.match(BASE64_REGEX).nil?
    end

    def base64_encode_if_needed(str)
      return str if base64_encoded?(str.to_s)

      Base64.encode64(str.to_s)
    end
  end
end
