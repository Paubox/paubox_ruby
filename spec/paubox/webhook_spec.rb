# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Paubox::Webhook do
  before do
    Paubox.configure do |config|
      config.api_key = 'test_key'
      config.api_user = 'test_user'
    end
  end
  
  describe '#create' do
    it 'checks the webhook created' do
      stub_request(:post, "https://api.paubox.net/v1/test_user/webhook_endpoints").to_return(status: 201)
      response = Paubox::Webhook.create(target_url: 'https://webhook.site/39848377', signing_key: 'test', api_key: 'api_key', active: 'true', events: ["api_mail_log_delivered"])
      expect(response.code).to eq 201
    end
  end

  
  describe '#update' do
    it 'checks the webhook updated' do    
      stub_request(:patch, "https://api.paubox.net/v1/test_user/webhook_endpoints/")
      response = Paubox::Webhook.new.update(target_url: 'https://webhook.site/39848377', signing_key: 'test', api_key: 'api_key', active: 'false', events: ["api_mail_log_delivered"])
      expect(response.code).to eq 200
    end
  end


  describe '#delete' do
    it 'checks the webhook deleted' do
      stub_request(:delete, "https://api.paubox.net/v1/test_user/webhook_endpoints/")
      response = Paubox::Webhook.new.delete      
      expect(response.code).to eq 200
    end
  end

  describe '#list' do
    it 'checks the webhook lists' do
      stub_request(:get, "https://api.paubox.net/v1/test_user/webhook_endpoints")
      response = Paubox::Webhook.list      
      expect(response.code).to eq 200
    end
  end
end
