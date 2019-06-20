# frozen_string_literal: true

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
      expected_content = { html_content: base64_encode_if_needed(multipart_message.html_part.body.to_s),
                           text_content: multipart_message.text_part.body.to_s }
      expect(content).to eq expected_content
    end

    it 'sets multipart html to html_content in html-only message' do
      builder = Paubox::MailToMessage.new(html_only_message)
      content = JSON.parse(builder.send(:send_message_payload))
      expected_content = { html_content: base64_encode_if_needed(multipart_message.html_part.body.to_s) }
      expect(content.dig('data', 'message', 'content', 'text/html')).to eq expected_content[:html_content]
      expect(content['text_content'].nil?).to be true
    end

    it 'extracts attachments and keeps contents in base64 encoding' do
      builder = Paubox::MailToMessage.new(message_with_attachments)
      attachments = builder.send(:build_attachments)
      attachment = attachments.first
      expect(Base64.decode64(attachment[:content])).to eq 'first, second'
      expect(attachment[:file_name].include?('.csv')).to be true
      expect(attachment[:content_type]).to eq 'text/csv'
    end

    it 'extracts html content and keeps contents in base64 encoding' do
      builder = Paubox::MailToMessage.new(html_only_message)
      content = builder.send(:build_content)
      expect(Base64.decode64(content[:html_content])).to eq '<h1>Test HTML</h1>'
    end

    it 'sets allow_non_tls attribute' do
      payload = Paubox::MailToMessage.new(multipart_message, allow_non_tls: true)
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'allowNonTLS')).to be true
    end

    it 'sets allow_non_tls to false default' do
      payload = Paubox::MailToMessage.new(multipart_message)
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'allowNonTLS')).to be false
    end

    it 'sets force_secure_notification attribute to false' do
      payload = Paubox::MailToMessage.new(multipart_message, force_secure_notification: 'false')
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'forceSecureNotification')).to be false
    end

    it 'sets force_secure_notification attribute to true' do
      payload = Paubox::MailToMessage.new(multipart_message, force_secure_notification: 'true')
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'forceSecureNotification')).to be true
    end

    it 'sets force_secure_notification attribute to nil default' do
      payload = Paubox::MailToMessage.new(multipart_message)
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'forceSecureNotification')).to be nil
    end

    it 'sets force_secure_notification attribute to empty' do
      payload = Paubox::MailToMessage.new(multipart_message, force_secure_notification: '')
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'forceSecureNotification')).to be nil
    end

    it 'sets force_secure_notification attribute to boolean value' do
      payload = Paubox::MailToMessage.new(multipart_message, force_secure_notification: true)
                                     .send_message_payload
      expect(JSON.parse(payload).dig('data', 'message', 'forceSecureNotification')).to be nil
    end

    it 'set and extract cc field' do
      builder = Paubox::MailToMessage.new(message_with_attachments)                                    
      content = builder.send(:build_parts)
      expected_content = ['cc@test.paubox.net']
      expect(content[:cc]).to eq expected_content
    end
  end
end
