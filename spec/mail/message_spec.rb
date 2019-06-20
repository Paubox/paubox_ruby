# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/mail_helper'

RSpec.configure do |c|
  c.include Helpers::MailHelper
end

RSpec.describe Mail::Message do
  describe 'extends class' do
    before do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
    end

    it 'sets source_tracking_id' do
      mail = message_with_attachments
      client = Paubox::Client.new
      stub_request(:post, client.send(:request_endpoint, 'messages'))
        .to_return(body: { 'message' => 'Service OK', 'sourceTrackingId' => '123' }.to_json,
                   status: 200, headers: { 'Content-Type' => 'application/json' })
      response = client.deliver_mail(mail)
      expect(mail.source_tracking_id).to eq '123'
    end
  end
end
