require 'spec_helper'
require './spec/helpers/mail_helper'

RSpec.configure do |c|
  c.include Helpers::MailHelper
end

RSpec.describe Mail::Paubox do
  describe '#deliver!' do
    before do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
    end

    it 'delivers a Mail message via the Transactional Email API' do
      mail = message_with_attachments
      client = Paubox::Client.new
      stub_request(:post, client.send(:request_endpoint, 'messages')).
        to_return(body: { 'message' => 'Service OK', 'sourceTrackingId' => '123' }.to_json,
                  status: 200,  headers: {'Content-Type' => 'application/json'})
      response = client.deliver_mail(mail)
      expect(JSON.parse(response.body)['message']).to eq 'Service OK'
    end
  end
end