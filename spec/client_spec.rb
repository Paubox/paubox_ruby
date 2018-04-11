require "spec_helper"

RSpec.describe Paubox::Client do
  describe '#initialize' do
    before do
      Paubox.configure do |config|
        config.api_key = 'test_key'
        config.api_user = 'test_user'
      end
    end

    it "allows default value to be overriden locally" do
      client = Paubox::Client.new(api_key: 'a_different_key')
      expect(client.api_key).to eq 'a_different_key'
    end
  end

  describe '#api_base_endpoint' do
    it 'returns the correct URI' do
      client = Paubox::Client.new(api_key: 'test_key', api_user: 'tester')
      expect(client.api_base_endpoint).to eq 'https://api.paubox.net/v1/tester'
    end
  end

  describe '#api_status' do
    it 'checks the API status' do
      client = Paubox::Client.new(api_key: 'test_key', api_user: 'paubox_api')
      stub_request(:get, client.request_endpoint('status'))
      response = client.api_status
      expect(response.code).to eq 200
    end
  end
end
