require 'spec_helper'
require './spec/helpers/message_helper'

RSpec.configure do |c|
  c.include Helpers::MessageHelper
end

RSpec.describe Paubox::Message do
  describe '#build_parts' do
    it 'builds headers' do
      message = Paubox::Message.new(message_with_attachment_args)
      tested_keys = %i[from reply_to subject]
      expected_results = message_defaults.select { |k, v| tested_keys.include?(k) }
      expect(message.build_headers).to eq expected_results
    end

    it 'builds content' do
      message = Paubox::Message.new(message_with_attachment_args)
      tested_keys = %i[text_content html_content]
      expected_results = message_with_attachment_args.select { |k, v| tested_keys.include?(k) }
      expect(message.build_content).to eq expected_results
    end

    it 'builds attachments' do
      message = Paubox::Message.new(message_with_attachment_args)
      message.build_attachments
      binding.pry
    end
  end
end