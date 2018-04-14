module Helpers
  module MessageHelper
    require 'base64'

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
      base_message_args({'body' => 'Test plain text body.'}.merge(args))
    end

    def multipart_message_args(args = {})
      base_message_args({ text_content: 'Plain text body.', html_content: '<h1>Test HTML</h1>' }.merge(args))
    end

    def message_with_attachment_args(args = {})
      multipart_message_args({ attachments: [ filename: 'test.csv', content_type: 'text/csv',
                                              content: 'first, second ' ] }.merge(args))
    end

    def base64_encoded?(str)
      encoded = Base64.encode64(str)
      encoded == Base64.encode64(Base64.decode64(encoded))
    end
  end
end
