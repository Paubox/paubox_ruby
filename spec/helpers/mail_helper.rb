module Helpers
  module MailHelper
    require 'base64'
    require 'mail'
    require 'tempfile'

    def mail_defaults
      { 'from' => 'me@test.paubox.net',
        'to' => 'you@test.paubox.net',
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
      base_message({'body' => 'Test plain text body.'}.merge(args))
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
  end
end
