# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/message_helper'
require 'tempfile'

RSpec.configure do |c|
  c.include Helpers::MessageHelper
end

RSpec.describe Paubox::Message do
  describe '#build_parts' do
    it 'builds headers' do
      message = Paubox::Message.new(message_with_attachment_args)
      tested_keys = %i[from reply_to subject]
      expected_results = message_defaults.select { |k, _v| tested_keys.include?(k) }
      expect(message.send(:build_headers)).to eq expected_results
    end

    it 'builds custom headers' do
      message_args = message_with_attachment_args.merge({
        custom_headers: {
          'header-1': 'Header-1-value',
          'Header-2': 'Header-2-value',
          'X-header-3': 'Header-3-value',
          'x-Header-4': 'Header-4-value'
        }
      })
      message = Paubox::Message.new(message_args)
      custom_headers = message.send(:build_custom_headers)
      normalized_header_keys = [1,2,3,4].map { |i| "x-header-#{i}" }
      normalized_header_keys.each do |k|
        expect(custom_headers[k]).to be_a(String)
      end
    end

    it 'builds content' do
      message = Paubox::Message.new(message_with_attachment_args)
      tested_keys = %i[text_content html_content]
      expected_results = message_with_attachment_encoded_args.select { |k, _v| tested_keys.include?(k) }
      expect(message.send(:build_content)).to eq expected_results
    end

    it 'adds attachments when instantiated' do
      message = Paubox::Message.new(message_with_attachment_args)
      expect(message.attachments.length).to be 1
    end

    it 'adds additional attachments with #add_attachment' do
      message = Paubox::Message.new(message_with_attachment_args)
      file = Tempfile.new(['test', '.csv'])
      begin
        file.write('first, second')
        message.add_attachment(file.path)
        expect(message.attachments.length).to be 2
      ensure
        file.close
        file.unlink
      end
    end

    it 'base64 encodes all attachment file contents' do
      message = Paubox::Message.new(message_with_attachment_args)
      file = Tempfile.new(['test', '.csv'])
      begin
        file.write('first, second')
        message.add_attachment(file.path)
        expect(message.attachments.map { |a| base64_encoded?(a[:content]) }.uniq).to eq [true]
      ensure
        file.close
        file.unlink
      end
    end

    it 'builds force secure notification string value' do
      message = Paubox::Message.new(message_with_force_secure_notification_string_args)
      tested_keys = %i[force_secure_notification]
      expected_results = true
      expect(message.send(:build_force_secure_notification)).to eq expected_results
    end

    it 'builds force secure notification boolean value' do
      message = Paubox::Message.new(message_with_force_secure_notification_boolean_args)
      tested_keys = %i[force_secure_notification]
      expected_results = true
      expect(message.send(:build_force_secure_notification)).to eq expected_results
    end

    it 'build parts sets cc' do
      message = Paubox::Message.new(message_with_attachment_args)
      expect(message.send(:build_parts)[:cc]).to eq ['first@test.paubox.com', 'second@paubox.com']
    end

    # it 'remaps hash keys for JSON request' do
    #   message = Paubox::Message.new(message_with_attachment_args)
    # end
  end
end
