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
      expected_results = message_defaults.select { |k, v| tested_keys.include?(k) }
      expect(message.send(:build_headers)).to eq expected_results
    end

    it 'builds content' do
      message = Paubox::Message.new(message_with_attachment_args)
      tested_keys = %i[text_content html_content]
      expected_results = message_with_attachment_encoded_args.select { |k, v| tested_keys.include?(k) }
      expect(message.send(:build_content)).to eq expected_results
    end

    it 'adds attachments when instantiated' do
      message = Paubox::Message.new(message_with_attachment_args)
      expect(message.attachments.length).to be 1
    end

    it 'adds additional attachments with #add_attachment' do
      message = Paubox::Message.new(message_with_attachment_args)
      file = Tempfile.new(['test', '.csv'])
      file.write('first, second')
      file.close
      message.add_attachment(file.path)
      expect(message.attachments.length).to be 2
    end

    it 'base64 encodes all attachment file contents' do
      message = Paubox::Message.new(message_with_attachment_args)
      file = Tempfile.new(['test', '.csv'])
      file.write('first, second')
      file.close
      message.add_attachment(file.path)
      expect(message.attachments.map { |a| base64_encoded?(a[:content]) }.uniq).to eq [true]
    end 
    
    it 'builds force secure notification valid value' do
      message = Paubox::Message.new(message_with_force_secure_notification_args)
      tested_keys = %i[force_secure_notification]
      expected_results = true
      expect(message.send(:build_force_secure_notification)).to eq expected_results
    end

    it 'builds force secure notification invalid value' do
      message = Paubox::Message.new(message_with_invalid_force_secure_notification_args)
      tested_keys = %i[force_secure_notification]
      expected_results = nil
      expect(message.send(:build_force_secure_notification)).to eq expected_results
    end

    # it 'remaps hash keys for JSON request' do
    #   message = Paubox::Message.new(message_with_attachment_args)
    # end
  end
end