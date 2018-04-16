require 'spec_helper'
require 'mail'
require './spec/helpers/mail_helper'

RSpec.configure do |c|
  c.include Helpers::MailHelper
end

RSpec.describe Paubox::MailToMessage do
  describe '#build_headers' do
    it 'returns a hash of headers' do
      args = { from: 'tester@test.com', reply_to: 'reply-to@test.com',
               subject: 'test subject' }
      builder = Paubox::MailToMessage.new(args)
      headers = builder.send(:build_headers)
      expect(args.values).to eq headers.values
    end
  end

  describe 'Mail object decomposition' do
    it 'extracts header fields' do
      builder = Paubox::MailToMessage.new(plain_text_message)
      headers = builder.send(:build_headers)
      expected_headers = { from: 'me@test.paubox.net',
                           reply_to: 'reply-to@test.paubox.net',
                           subject: 'Test subject' }
      expect(headers).to eq expected_headers
    end

    it 'extracts non-multipart body' do
      builder = Paubox::MailToMessage.new(plain_text_message)
      content = builder.send(:build_content)
      expected_content = { text_content: plain_text_message.body.to_s }
      expect(content).to eq expected_content
    end

    it 'extracts multipart html and text bodies' do
      builder = Paubox::MailToMessage.new(multipart_message)
      content = builder.send(:build_content)
      expected_content = { html_content: multipart_message.html_part.body.to_s,
        text_content: multipart_message.text_part.body.to_s }
      expect(content).to eq expected_content
    end

    it 'extracts attachments and keeps contents in base64 encoding' do
      builder = Paubox::MailToMessage.new(message_with_attachments)
      attachments = builder.send(:build_attachments)
      attachment = attachments.first
      expect(Base64.decode64(attachment[:content])).to eq 'first, second'
      expect(attachment[:file_name].include?('.csv')).to be true
      expect(attachment[:content_type]).to eq 'text/csv'
    end
  end
end

