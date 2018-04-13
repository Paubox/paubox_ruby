require "spec_helper"

RSpec.describe Paubox::Client do
  describe '#initialize' do
    before do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
    end

    it 'can override default parameters' do
      client = Paubox::Client.new(api_key: 'test_key', api_user: 'paubox_test',
        api_protocol: '', api_host: 'localhost:3000', api_version: 'v2')
      expect(client.send(:request_endpoint, 'test')).to eq 'localhost:3000/v2/paubox_test/test'
    end
  end

  describe '#api_base_endpoint' do
    it 'returns the correct URI' do
      client = Paubox::Client.new
      expect(client.send(:api_base_endpoint)).to eq 'https://api.paubox.net/v1/test_user'
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
end
