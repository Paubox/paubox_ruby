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
end
