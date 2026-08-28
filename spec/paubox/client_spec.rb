# frozen_string_literal: true

require 'spec_helper'
require './spec/helpers/email_disposition_helper'

RSpec.configure do |c|
  c.include Helpers::EmailDispositionHelper
end

RSpec.describe Paubox::Client do
  describe '#initialize' do
    before do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
    end

    it 'can override default parameters' do
      client = Paubox::Client.new(api_key: 'test_key',
                                  api_protocol: '', api_host: 'localhost:3000', api_version: 'v2')
      expect(client.send(:request_endpoint, 'test')).to eq 'localhost:3000/v2/email/test'
    end
  end

  describe '#api_base_endpoint' do
    it 'returns the correct URI' do
      client = Paubox::Client.new
      expect(client.send(:api_base_endpoint)).to eq 'https://api.paubox.com/v1/email'
    end

    it 'ignores api_user (deprecated no-op kept for backward compatibility)' do
      client = Paubox::Client.new(api_key: 'test_key', api_user: 'paubox_test')
      expect(client.api_user).to eq 'paubox_test'
      expect(client.send(:api_base_endpoint)).to eq 'https://api.paubox.com/v1/email'
    end
  end

  describe '#api_status' do
    it 'checks the API status' do
      client = Paubox::Client.new(api_key: 'test_key', api_user: 'paubox_api')
      stub_request(:get, client.send(:request_endpoint, 'status'))
      response = client.api_status
      expect(response.code).to eq 200
    end
  end

  describe '#send_request' do
    it 'send request to API successfully' do
      client = Paubox::Client.new
      stub_request(:post, client.send(:request_endpoint, 'dynamic_templates'))
      response = client.send_request(method: :post, payload: {}, path: 'dynamic_templates')
      expect(response.code).to eq 200
    end
  end

  describe '#schedule_mail' do
    it 'posts to the schedule endpoint' do
      client = Paubox::Client.new(api_key: 'test_key')
      stub_request(:post, client.send(:request_endpoint, 'schedule'))
        .to_return(status: 200, body: '{"sourceTrackingId":"tid","scheduledAt":"2025-12-25T15:00:00Z","state":"pending","data":"Service OK"}')
      mail = { from: 'sender@example.com', to: ['recipient@example.com'], subject: 'Test', text_content: 'Hello' }
      response = client.schedule_mail(mail, '2025-12-25T15:00:00Z')
      expect(response['state']).to eq 'pending'
    end
  end

  describe '#get_scheduled' do
    it 'gets scheduled message status' do
      client = Paubox::Client.new(api_key: 'test_key')
      stub_request(:get, client.send(:request_endpoint, 'schedule/tid-123'))
        .to_return(status: 200, body: '{"sourceTrackingId":"tid-123","state":"pending"}')
      response = client.get_scheduled('tid-123')
      expect(response['state']).to eq 'pending'
    end
  end

  describe '#reschedule' do
    it 'patches the scheduled message' do
      client = Paubox::Client.new(api_key: 'test_key')
      stub_request(:patch, client.send(:request_endpoint, 'schedule/tid-123'))
        .to_return(status: 200, body: '{"sourceTrackingId":"tid-123","scheduledAt":"2025-12-26T10:00:00Z","data":"Rescheduled"}')
      response = client.reschedule('tid-123', '2025-12-26T10:00:00Z')
      expect(response['data']).to eq 'Rescheduled'
    end
  end

  describe '#cancel_scheduled' do
    it 'cancels a scheduled message' do
      client = Paubox::Client.new(api_key: 'test_key')
      stub_request(:post, client.send(:request_endpoint, 'schedule/tid-123/cancel'))
        .to_return(status: 200, body: '{"sourceTrackingId":"tid-123","state":"cancelled","data":"Cancelled"}')
      response = client.cancel_scheduled('tid-123')
      expect(response['state']).to eq 'cancelled'
    end
  end
end
