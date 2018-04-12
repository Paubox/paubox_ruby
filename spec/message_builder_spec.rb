require 'spec_helper'
require 'mail'
require 'tempfile'

RSpec.describe Paubox::MessageBuilder do
  def mail_defaults
    { 'from' => 'me@test.paubox.net',
      'to' => 'you@test.paubox.net',
      'reply_to' => 'reply-to@test.paubox.net',
      'subject' => 'Test subject' }
  end

  def base_message(args = {})
    args = mail_defaults.merge(args)
    mail = Mail.new
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

  describe '#build_headers' do
    it 'returns a hash of headers' do
      args = { from: 'tester@test.com', reply_to: 'reply-to@test.com', subject: 'test subject' }
      builder = Paubox::MessageBuilder.new(args)
      headers = builder.send(:build_headers)
      expect(args.values).to eq headers.values
    end
  end

  describe 'Mail object decomposition' do
    it 'extracts header fields' do
      builder = Paubox::MessageBuilder.new(plain_text_message)
      headers = builder.send(:build_headers)
      expected_headers = {'from' => 'me@test.paubox.net',
        'reply-to' => 'reply-to@test.paubox.net', 'subject'=>'Test subject'}
      expect(headers).to eq expected_headers
    end

    it 'extracts non-multipart body' do
      builder = Paubox::MessageBuilder.new(plain_text_message)
      content = builder.send(:build_content)
      expected_content = { 'text/plain' => plain_text_message.body.to_s }
      expect(content).to eq expected_content
    end

    it 'extracts multipart html and text bodies' do
      builder = Paubox::MessageBuilder.new(multipart_message)
      content = builder.send(:build_content)
      expected_content = { 'text/html' => multipart_message.html_part.body.to_s,
        'text/plain' => multipart_message.text_part.body.to_s }
      expect(content).to eq expected_content
    end

    it 'extracts attachments and keeps contents in base64 encoding' do
      builder = Paubox::MessageBuilder.new(message_with_attachments)
      attachments = builder.send(:build_attachments)
      attachment = attachments.first
      expect(Base64.decode64(attachment['content'])).to eq 'first, second'
      expect(attachment['fileName'].include?('.csv')).to be true
      expect(attachment['contentType']).to eq 'text/csv'
    end
  end
end

